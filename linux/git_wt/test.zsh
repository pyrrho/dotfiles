#!/usr/bin/env zsh
set -eu

autoload -Uz compinit
compinit -D
alias gwt=true gwta=true gwtls=true gwtmv=true gwtrm=true
source "${0:A:h}/source.zsh"

root=$(mktemp -d)
trap 'cd /; rm -rf -- "$root"' EXIT
git init -q -b main "$root/repo"
cd "$root/repo"
GIT_COMMITTER_DATE='2020-01-01T00:00:00Z' \
git -c user.name=Test -c user.email=test@example.com -c commit.gpgsign=false \
    commit -q --allow-empty -m Initial
git checkout -q --detach
git branch unlinked
git worktree add -q -b topic "$root/.repo_worktrees/attached"
git worktree add -q --detach "$root/.repo_worktrees/detached"
GIT_COMMITTER_DATE='2022-01-01T00:00:00Z' \
git -C "$root/.repo_worktrees/detached" -c user.name=Test \
    -c user.email=test@example.com -c commit.gpgsign=false \
    commit -q --allow-empty -m Newer
newer=$(git -C "$root/.repo_worktrees/detached" rev-parse HEAD)
git branch z-newest "$newer"
git update-ref refs/remotes/origin/z-newest "$newer"
git update-ref refs/remotes/other/z-newest HEAD
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/z-newest

expected="detached:[detached HEAD] $root/.repo_worktrees/detached
repo:[detached HEAD] $root/repo
attached:[topic]         $root/.repo_worktrees/attached"
actual=$(__gw_worktree_completion_options)
if [[ "$actual" != "$expected" ]]; then
    print -u2 -- "Unexpected directory completions:\n$actual"
    exit 1
fi
[[ "$(__gw_worktree_completion_options @)" = "@topic:$root/.repo_worktrees/attached" ]]

# A branch label longer than [detached HEAD] must widen the column too.
git branch -m topic 12345678901234567890
[[ "$(__gw_worktree_completion_options)" = "detached:[detached HEAD]        $root/.repo_worktrees/detached
repo:[detached HEAD]        $root/repo
attached:[12345678901234567890] $root/.repo_worktrees/attached" ]]
git branch -m 12345678901234567890 topic

# Capture the candidates passed to zsh's renderer, keeping Git queries real.
function _describe {
    case "$2" in
        worktrees) rendered_worktrees=("${(@P)5}") ;;
        local-branches) rendered_branches=("${(@P)5}") ;;
        remote-branches) rendered_remotes=("${(@P)5}") ;;
    esac
    return 0
}
typeset -a rendered_worktrees rendered_branches rendered_remotes
PREFIX=''
_gwt_completion
[[ "${(F)rendered_worktrees}" = "$expected" ]]
[[ "${(j: :)rendered_branches}" = '@z-newest @main @unlinked' ]]
[[ "${(j: :)rendered_remotes}" = '@origin/z-newest @other/z-newest' ]]
PREFIX=@
_gwt_completion
[[ "${(F)rendered_worktrees}" = "@topic:$root/.repo_worktrees/attached" ]]
[[ "${(j: :)rendered_branches}" = '@z-newest @main @unlinked' ]]
[[ "${(j: :)rendered_remotes}" = '@origin/z-newest @other/z-newest' ]]

gwt attached
[[ "$PWD" = "$root/.repo_worktrees/attached" ]]
gwt repo
[[ "$PWD" = "$root/repo" ]]
gwt @topic
[[ "$PWD" = "$root/.repo_worktrees/attached" ]]
gwt detached
[[ "$PWD" = "$root/.repo_worktrees/detached" ]]
gwt repo
[[ "$PWD" = "$root/repo" ]]
gwt @origin/z-newest
[[ "$(git rev-parse HEAD)" = "$newer" ]]
[[ "$PWD" = "$root/.repo_worktrees/origin/z-newest" ]]
gwt repo
gwrm -b @topic
PREFIX=@
_gwt_completion
[[ -z "${(F)rendered_worktrees}" ]]

# gwn always takes a directory name; -c independently names the new branch.
gwn branch-dir main -c created
[[ "$PWD" = "$root/.repo_worktrees/branch-dir" ]]
[[ "$(git branch --show-current)" = created ]]
[[ "$(git rev-parse HEAD)" = "$(git rev-parse main)" ]]
gwt detached
gwn default-branch -c from-current
[[ "$(git branch --show-current)" = from-current ]]
[[ "$(git rev-parse HEAD)" = "$newer" ]]
gwn default-detached
[[ -z "$(git branch --show-current)" ]]
[[ "$(git rev-parse HEAD)" = "$newer" ]]
gwn explicit-detached main
[[ -z "$(git branch --show-current)" ]]
[[ "$(git rev-parse HEAD)" = "$(git rev-parse main)" ]]
before=$PWD
function expect_gwn_failure {
    if gwn "$@"; then
        print -u2 -- "Expected gwn to fail: $*"
        exit 1
    fi
}
expect_gwn_failure missing-branch -c
expect_gwn_failure extra main unexpected
expect_gwn_failure @old-syntax
expect_gwn_failure invalid -c ''
expect_gwn_failure duplicate -c first -c second
expect_gwn_failure existing-branch -c created
[[ "$PWD" = "$before" ]]
[[ ! -d "$root/.repo_worktrees/missing-branch" ]]

# Options can surround positionals, including grouped gwrm flags.
for placement in 1 2 3 4 5 6; do
    gwt detached
    name="option-order-$placement"
    branch="branch-$placement"
    case "$placement" in
        1|4) gwn -c "$branch" "$name" main ;;
        2|5) gwn "$name" -c "$branch" main ;;
        3|6) gwn "$name" main -c "$branch" ;;
    esac
    [[ "$PWD" = "$root/.repo_worktrees/$name" ]]
    [[ "$(git branch --show-current)" = "$branch" ]]
    [[ "$(git rev-parse HEAD)" = "$(git rev-parse main)" ]]
    print dirty > untracked-file
    case "$placement" in
        1) gwrm -b -f "$name" ;;
        2) gwrm -b "$name" -f ;;
        3) gwrm "$name" -bf ;;
        4) gwrm -fb "$name" ;;
        5) gwrm "$name" -f -b ;;
        6) gwrm -f "@$branch" -b ;;
    esac
    [[ ! -d "$root/.repo_worktrees/$name" ]]
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        print -u2 -- "gwrm failed to delete $branch"
        exit 1
    fi
done

git worktree add -q -b separator "$root/.repo_worktrees/-f" main
if gwrm -- -f -b; then
    print -u2 'gwrm interpreted an option after --'
    exit 1
fi
if gwrm -f -z; then
    print -u2 'gwrm accepted an unknown option'
    exit 1
fi
[[ -d "$root/.repo_worktrees/-f" ]]
gwrm -b -- -f
[[ ! -d "$root/.repo_worktrees/-f" ]]
if git show-ref --verify --quiet refs/heads/separator; then
    exit 1
fi
print 'PASS: directory and branch completions, detached main checkout, and navigation'
