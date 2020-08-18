alias l='ls -GhF'
alias la='ls -aGhF'
alias l1='ls -1GhF'

alias cpr='cp -r'

alias rf='rm -rf'

alias 1='$(fc -ln -1)' # Easier to type `!!`

alias c='pyc'

alias goto_subl_packages="cd \"/Users/drew/Library/Application Support/Sublime Text 3/Packages\""

alias bzl='bazel'
alias bb='bazel build'
alias br='bazel run'


function mkcscope()
{
    local top=`pwd`

    pushd / > /dev/null
    find "${top}" -name \*.[chsS] -printf "\"%p\"\n" > "${top}/cscope.files"
    find "${top}" -name \*.cpp -printf "\"%p\"\n" >> "${top}/cscope.files"
    find "${top}" -name \*.cxx -printf "\"%p\"\n" >> "${top}/cscope.files"
    find "${top}" -name \*.hpp -printf "\"%p\"\n" >> "${top}/cscope.files"
    find "${top}" -name \*.cxx -printf "\"%p\"\n" >> "${top}/cscope.files"
    popd > /dev/null
    cscope -bq
    rm -f "${top}/cscope.files"
}

function set_cs()
{
    export CSCOPE_DB="`pwd`/cscope.out"
}

function diffly()
{
    /usr/bin/diff -w -y $@ -W $(( $(tput cols) - 9 )) | colordiff | less -RN
}

function pyc()
{
    python -c "from math import *; print $*"
}

function chirp()
{
    ( ( afplay /System/Library/Sounds/Purr.aiff -v 30 &&
        afplay /System/Library/Sounds/Purr.aiff -v 30 ) & ) > /dev/null 2>&1
}

function chirp_fail()
{
    ( ( afplay /System/Library/Sounds/Basso.aiff -v 10 ) & ) > /dev/null 2>&1
}

function alert()
{
    local ret=$?
    if [[ $ret == 0 ]]; then
      chirp
    else
      chirp_fail
    fi
    return $ret
}

function chirp_forever()
{
    while true; do chirp; sleep 3; done
}

DISABLE_AUTO_TITLE="false"
function titles()
{
    if [ "$DISABLE_AUTO_TITLE" = "true" ]; then
        export DISABLE_AUTO_TITLE="false"
    else
        export DISABLE_AUTO_TITLE="true"
        if [ $# -gt 0 ]; then
            title "$*"
        else
            echo -ne "\e]1;zsh\a"
        fi
    fi
}
