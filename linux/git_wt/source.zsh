# Git Worktrees
# but my way
#
# tl;dr - a few commands for making the `git worktree` command set more fun.
#
# - `gwl` -- `[g]it [w]orktree [l]ist`
#   List active worktrees
# - `gwt` -- `[g]it [w]orktree [t]ake`
#   `cd` to the worktree with the given directory name. An `@branch` argument
#   instead selects the worktree containing that branch, creating it if needed.
#   Tab completion lists worktrees, unlinked local branches, then remote
#   branches. Each section is newest commit first, by committer date.
#   Type `@` to complete attached branches instead of worktree directories.
#   Remote selectors include the remote, e.g. `@origin/topic`; Git creates a
#   detached worktree at that remote-tracking ref.
# - `gwrm` -- `[g]it [w]orktree [r]e[m]ove`
#   Delete the worktree with the given directory name, or the worktree
#   containing an `@branch`. `-b` also deletes its attached branch, and `-f`
#   forces removal.
#   NB. Tab completion works with this command.
#   NB. idk what happens if you try to delete the main worktree. Worth trying?
# - `gwn` -- `[g]it [w]orktree [n]ew`
#   `gwn name [start-point]` creates a detached worktree. `gwn @branch
#   [start-point [name]]` creates a new branch and worktree, using the branch
#   name as the directory name when no name is given.
#
#
# A NOTE ON DIRECTORY LAYOUTS
# Because I never want to think about where my worktrees live, `gwt` can be used
# to cd into existing worktrees by directory or branch, or to create a worktree
# for an existing branch. `gwn` creates detached worktrees and new branches.
#
# Worktrees managed by these commands are created in a sister directory of the
# main repository: `.<repo>_worktrees/<name>`, where <repo> is the base directory
# of the main repository and <name> is the supplied directory or branch name.
# See A NOTE ON FINDING THE WORKTREE ROOT to see how to consistently find the
# worktree root.
#
#
# A NOTE ON FINDING THE WORKTREE ROOT
# Executing `git rev-parse --git-common-dir` returns one of two things;
# - When executed in the main worktree (a `git clone`d repo) it will return a
#   relative path to the .git directory of the current repository.
# - When executed in a linked worktree (a `git worktree add`d repo) it will
#   return an absolute path to the main worktree's .git directory.
#
# In either case, we can `realpath $(...)` the output of that commad to get an
# absolute path. Then we can nest a pair of `dirname` calls to strip the .git
# directory and the main worktree directory. And then we have a root.

# Unset git worktree ailases porvided by the ohmyzsh git plugin
unalias gwt
unalias gwta
unalias gwtls
unalias gwtmv
unalias gwtrm

# Functions!

function __gw_require_repo {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "ERROR: it looks like you're not in a git repo?"
        return 1
    fi
}

function __gw_validate_selector {
    local selector="$1"

    if [[ "${selector}" = @* ]]; then
        if [ -z "${selector#@}" ]; then
            echo "ERROR: a branch selector requires a name after '@'"
            return 1
        fi
        return 0
    fi

    __gw_validate_directory_name "${selector}"
}

function __gw_validate_directory_name {
    local name="$1"

    if [[ -z "${name}" || "${name}" = @* || "${name}" = /* || \
        "${name}" = */ || "${name}" = *//* || "${name}" = "." || \
        "${name}" = ".." || "${name}" = ./* || "${name}" = */./* || \
        "${name}" = */. || "${name}" = ../* || "${name}" = */../* || \
        "${name}" = */.. ]]; then
        echo "ERROR: '${name}' is not a worktree directory name"
        return 1
    fi
}

function gwl {
    __gw_require_repo || return $?
    git worktree list
}

alias gcd=gwt
function gwt {
    __gw_require_repo || return $?
    if [ $# -ne 1 ]; then
        echo "ERROR: \`gwt\` requires exactly 1 argument"
        return 1
    fi
    __gw_validate_selector "$1" || return $?

    local wt_path
    if wt_path=$(__gw_find_worktree "$1"); then
        cd -- "${wt_path}"
        return $?
    fi

    if [[ "$1" != @* ]]; then
        echo "ERROR: failed to find a worktree directory named '$1'"
        return 1
    fi

    local branch=${1#@}
    local wt_root=$(__gw_get_worktrees_root) || return $?
    wt_path="${wt_root}/${branch}"
    git worktree add "${wt_path}" "${branch}"
    if [ $? -eq 0 ]; then
        cd -- "${wt_path}"
    fi
}

function _gwt_completion {
    __gw_require_repo >/dev/null || return $?

    local -a worktrees local_branches remote_branches
    worktrees=("${(@f)$(__gw_worktree_completion_options "${PREFIX}")}")

    local ref symref wt_path
    while IFS='|' read -r ref symref wt_path; do
        [[ -n "${symref}" ]] && continue
        case "${ref}" in
            refs/heads/*)
                [[ -n "${wt_path}" ]] && continue
                local_branches+=("@${ref#refs/heads/}")
                ;;
            refs/remotes/*)
                remote_branches+=("@${ref#refs/remotes/}")
                ;;
        esac
    done < <(git for-each-ref --sort=-committerdate \
        --format='%(refname)|%(symref)|%(worktreepath)' refs/heads refs/remotes)

    local ret=1
    _describe -t worktrees -V 'worktrees' worktrees && ret=0
    _describe -t local-branches -V 'local branches' local_branches && ret=0
    _describe -t remote-branches -V 'remote branches' remote_branches && ret=0
    return $ret
}
zstyle ':completion:*:*:gwt:*' group-name ''
zstyle ':completion:*:*:gwt:*' group-order worktrees local-branches remote-branches
zstyle ':completion:*:*:gwt:*' list-grouped false
zstyle ':completion:*:*:gwt:*:descriptions' format '----- %d'
compdef _gwt_completion gwt

unfunction gwrmb gwrf 2>/dev/null || true
compdef -d gwrmb gwrf 2>/dev/null || true

function gwrm {
    __gw_require_repo || return $?

    local delete_branch=no
    local force=no
    local option
    local OPTIND=1
    while getopts ':bf' option; do
        case "${option}" in
            b)
                delete_branch=yes
                ;;
            f)
                force=yes
                ;;
            \?)
                echo "ERROR: unknown option '-${OPTARG}'"
                echo "ERROR: usage: gwrm [-b] [-f] <directory|@branch>"
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    if [ $# -ne 1 ]; then
        echo "ERROR: usage: gwrm [-b] [-f] <directory|@branch>"
        return 1
    fi
    __gw_validate_selector "$1" || return $?

    local worktree_count=$(git worktree list --porcelain | \
        awk '$1 == "worktree" { count++ } END { print count }')
    if [ "${worktree_count}" -eq 1 ]; then
        echo "ERROR: do you really want to delete the last active worktree?"
        return 1
    fi

    local wt_path
    if ! wt_path=$(__gw_find_worktree "$1"); then
        echo "ERROR: failed to find a worktree matching '$1'"
        return 1
    fi

    local branch=$(git -C "${wt_path}" symbolic-ref --quiet --short HEAD \
        2>/dev/null)
    __gw_leave_worktree "${wt_path}" || return $?

    if [ "${force}" = yes ]; then
        git worktree remove --force "${wt_path}"
    else
        git worktree remove "${wt_path}"
    fi
    local remove_status=$?
    if [ "${remove_status}" -ne 0 ]; then
        return "${remove_status}"
    fi

    if [ "${delete_branch}" = yes ]; then
        if [ -n "${branch}" ]; then
            git branch -D -- "${branch}"
        else
            echo "WARNING: the removed worktree was not attached to a branch"
        fi
    fi
}

function _gwrm_completion {
    __gw_require_repo >/dev/null || return $?

    local context state line
    local -A opt_args
    _arguments -s \
        '-b[delete the attached branch]' \
        '-f[force removal]' \
        '1:worktree:->worktree' && return 0

    if [ "${state}" = worktree ]; then
        local -a worktrees
        worktrees=("${(@f)$(__gw_worktree_completion_options "${PREFIX}")}")
        _describe -V 'worktrees' worktrees
    fi
}
compdef _gwrm_completion gwrm

function gwn {
    __gw_require_repo || return $?
    if [ $# -lt 1 ] || [ $# -gt 3 ]; then
        echo "ERROR: usage: gwn name [start-point]"
        echo "             gwn @branch [start-point [name]]"
        return 1
    fi
    __gw_validate_selector "$1" || return $?

    local wt_root=$(__gw_get_worktrees_root) || return $?
    if [[ "$1" = @* ]]; then
        local branch=${1#@}
        local start_point=${2:-HEAD}
        local name=${branch}
        if [ $# -eq 3 ]; then
            name=$3
            __gw_validate_directory_name "${name}" || return $?
        fi

        local wt_path="${wt_root}/${name}"
        git worktree add -b "${branch}" "${wt_path}" "${start_point}"
    else
        if [ $# -eq 3 ]; then
            echo "ERROR: usage: gwn name [start-point]"
            return 1
        fi

        local start_point=${2:-HEAD}
        local wt_path="${wt_root}/$1"
        git worktree add --detach "${wt_path}" "${start_point}"
    fi

    if [ $? -eq 0 ]; then
        cd -- "${wt_path}"
    fi
}

function _gwn_completion {
    __gw_require_repo >/dev/null || return $?

    case "${CURRENT}" in
        2)
            compadd -x '<directory-name>'
            compadd -x '@<branch-name>'
            ;;
        3)
            local -a branches
            branches=("${(@f)$(__gw_list_branches)}")
            _describe -V 'branches' branches
            ;;
        4)
            if [[ "${words[2]}" = @* ]]; then
                compadd -x '<directory-name>'
            fi
            ;;
    esac
}
compdef _gwn_completion gwn

function __gw_get_worktrees_root {
    __gw_require_repo || return $?

    local main_repo_path=$(dirname \
        "$(realpath "$(git rev-parse --git-common-dir)")")
    local repo_root_path=$(dirname "${main_repo_path}")
    local main_repo_name=$(basename "${main_repo_path}")

    local worktrees_path="${repo_root_path}/.${main_repo_name}_worktrees"

    if [ ! -d "${worktrees_path}" ]; then
        mkdir -p "${worktrees_path}" || return $?
    fi

    echo "${worktrees_path}"
}

function __gw_find_worktree {
    local selector="$1"
    local branch=""
    local expected_path=""

    if [[ "${selector}" = @* ]]; then
        branch=${selector#@}
    else
        local wt_root=$(__gw_get_worktrees_root) || return $?
        local main_repo_path=$(dirname \
            "$(realpath "$(git rev-parse --git-common-dir)")")
        if [[ "${selector}" = "${main_repo_path:t}" ]]; then
            expected_path=${main_repo_path}
        else
            expected_path="${wt_root}/${selector}"
        fi
    fi

    local line
    local wt_path
    while IFS= read -r line; do
        case "${line}" in
            worktree\ *)
                wt_path=${line#worktree }
                if [[ -n "${expected_path}" && \
                    "${wt_path}" = "${expected_path}" ]]; then
                    echo "${wt_path}"
                    return 0
                fi
                ;;
            branch\ refs/heads/*)
                if [[ -n "${branch}" && \
                    "${line#branch refs/heads/}" = "${branch}" ]]; then
                    echo "${wt_path}"
                    return 0
                fi
                ;;
        esac
    done < <(git worktree list --porcelain)

    return 1
}

function __gw_leave_worktree {
    local wt_path="$1"
    local current_path=$(pwd -P)
    if [[ "${current_path}" != "${wt_path}" && \
        "${current_path}" != "${wt_path}"/* ]]; then
        return 0
    fi

    local line
    local fallback_path
    while IFS= read -r line; do
        if [[ "${line}" = worktree\ * ]]; then
            fallback_path=${line#worktree }
            if [ "${fallback_path}" != "${wt_path}" ]; then
                cd -- "${fallback_path}"
                return $?
            fi
        fi
    done < <(git worktree list --porcelain)

    echo "ERROR: failed to find another worktree to enter before removal"
    return 1
}

function __gw_worktree_completion_options {
    local wt_root=$(__gw_get_worktrees_root) || return $?
    local main_repo_path=$(dirname \
        "$(realpath "$(git rev-parse --git-common-dir)")")
    local line
    local wt_path
    local wt_branch
    local commit_date

    while IFS= read -r line; do
        case "${line}" in
            worktree\ *)
                wt_path=${line#worktree }
                wt_branch=""
                commit_date=0
                ;;
            HEAD\ *)
                commit_date=$(git show -s --format=%ct "${line#HEAD }" 2>/dev/null) || commit_date=0
                ;;
            branch\ refs/heads/*)
                wt_branch=${line#branch refs/heads/}
                ;;
            "")
                if [[ "${1:-}" = @* ]]; then
                    if [ -n "${wt_branch}" ]; then
                        printf '%s\t%s\t%s\t%s\n' "$commit_date" "@${wt_branch}" "" "$wt_path"
                    fi
                elif [[ "${wt_path}" = "${main_repo_path}" ]]; then
                    printf '%s\t%s\t%s\t%s\n' "$commit_date" "${main_repo_path:t}" "[${wt_branch:-"detached HEAD"}]" "$wt_path"
                elif [[ "${wt_path}" = "${wt_root}"/* ]]; then
                    printf '%s\t%s\t%s\t%s\n' "$commit_date" "${wt_path#${wt_root}/}" "[${wt_branch:-"detached HEAD"}]" "$wt_path"
                fi
                ;;
        esac
    done < <(git worktree list --porcelain) | sort -s -k1,1nr | awk -F '\t' '
        {
            selectors[NR] = $2
            labels[NR] = $3
            paths[NR] = $4
            if (length($3) > width) width = length($3)
        }
        END {
            for (i = 1; i <= NR; i++) {
                printf "%s:", selectors[i]
                if (labels[i] != "") printf "%-*s ", width, labels[i]
                printf "%s\n", paths[i]
            }
        }'
}

function __gw_list_branches {
    local ref
    local symref
    local branch

    while read -r ref symref; do
        if [ -n "${symref}" ]; then
            continue
        fi

        case "${ref}" in
            refs/heads/*)
                echo "${ref#refs/heads/}"
                ;;
            refs/remotes/*)
                branch=${ref#refs/remotes/}
                echo "${branch#*/}"
                ;;
        esac
    done < <(git for-each-ref --sort=-committerdate \
        --format='%(refname) %(symref)' refs/heads refs/remotes) | \
        awk '!seen[$0]++'
}
