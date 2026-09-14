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
git -c user.name=Test -c user.email=test@example.com -c commit.gpgsign=false \
    commit -q --allow-empty -m Initial
git checkout -q --detach
git branch unlinked
git worktree add -q -b topic "$root/.repo_worktrees/attached"
git worktree add -q --detach "$root/.repo_worktrees/detached"

expected="repo:$root/repo
attached:$root/.repo_worktrees/attached
detached:$root/.repo_worktrees/detached"
actual=$(__gw_worktree_completion_options)
if [[ "$actual" != "$expected" ]]; then
    print -u2 -- "Unexpected directory completions:\n$actual"
    exit 1
fi
[[ "$(__gw_worktree_completion_options @)" = "@topic:$root/.repo_worktrees/attached" ]]

# Capture the candidates passed to zsh's renderer, keeping Git queries real.
function _describe {
    case "$2" in
        worktrees) rendered_worktrees=("${(@P)5}") ;;
        branches) rendered_branches=("${(@P)5}") ;;
    esac
    return 0
}
typeset -a rendered_worktrees rendered_branches
PREFIX=''
_gwt_completion
[[ "${(F)rendered_worktrees}" = "$expected" ]]
[[ "${(j: :)${(o)rendered_branches}}" = '@main:branch @unlinked:branch' ]]
PREFIX=@
_gwt_completion
[[ "${(F)rendered_worktrees}" = "@topic:$root/.repo_worktrees/attached" ]]
[[ "${(j: :)${(o)rendered_branches}}" = '@main:branch @unlinked:branch' ]]

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
gwrm -b @topic
PREFIX=@
_gwt_completion
[[ -z "${(F)rendered_worktrees}" ]]
print 'PASS: directory and branch completions, detached main checkout, and navigation'
