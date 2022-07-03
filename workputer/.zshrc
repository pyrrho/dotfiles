# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mortalscumbag"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git dotnet npm nvm ripgrep rsync)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# GPG Keys for kcf2aws
# export GPGKEY=B36A488A83C13456D00C40FB83820CA7CBC66226
# export GPG_TTY=$(tty)

# Get kcf2aws commands loaded
source ${HOME}/kcf/utils/kcf2aws/kcf2aws.sh

alias rf="rm -rf"
alias ll="ls -lAh"
alias la="ls -lah"
alias l1="ls -1"

function prg()
{
    ps aux | rg $@ | less -F -X
}

function hrg()
{
    history | rg $@ | less -F -X
}


alias psql-pwd-sddev01="aws secretsmanager get-secret-value --secret-id postgresql-dev-master-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-sddev02="aws secretsmanager get-secret-value --region=eu-central-1 --secret-id timescale-dev-application-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-sddev02-perf="aws secretsmanager get-secret-value --region=eu-central-1 --secret-id tsdbperf-dev-application-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-zudo-sddev02="aws secretsmanager get-secret-value --region=eu-central-1 --secret-id timescale-dev-super-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-zudo-sddev02-perf="aws secretsmanager get-secret-value --region=eu-central-1 --secret-id tsdbperf-dev-super-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-sddev03="aws secretsmanager get-secret-value --secret-id postgresql02-dev-master-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-sddev04="aws secretsmanager get-secret-value --secret-id pgsql-dev-master-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-sddev06="aws secretsmanager get-secret-value --secret-id timescale-forge-admin | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-sdstage01="aws secretsmanager get-secret-value --secret-id postgresql-stage-master-creds | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-sdstage02="aws secretsmanager get-secret-value --secret-id postgresql-stage-master-creds --region us-east-2 | jq '.SecretString | fromjson.password' | unquote"
alias psql-pwd-prod01="db-aws-login.sh prod"
alias psql-pwd-prod01-rw="aws secretsmanager get-secret-value --secret-id postgresql-prod-master-creds | jq '.SecretString | fromjson.password' | unquote"

alias psql-connect-sddev01="psql -h postgresql-dev.cluster-ro-ctsjedishmew.us-east-1.rds.amazonaws.com -U kcfmaster1"
alias psql-connect-rw-sddev01="psql -h postgresql-dev.cluster-ctsjedishmew.us-east-1.rds.amazonaws.com -U kcfmaster1"
alias psql-connect-zudo-sddev02="psql -h tsdb-ro.sddev02.kcftech.com -U kcfmaster1 -d prometheus"
alias psql-connect-zudo-rw-sddev02="psql -h tsdb-rw.sddev02.kcftech.com -U kcfmaster1 -d prometheus"
alias psql-connect-zudo-sddev02-perf="psql -h tsdbperf-ro.sddev02.kcftech.com -U kcfmaster1 -d prometheus"
alias psql-connect-zudo-rw-sddev02-perf="psql -h tsdbperf-rw.sddev02.kcftech.com -U kcfmaster1 -d prometheus"
alias psql-connect-sddev06="psql -h internal-kairosdb-dev-1150060957.us-east-1.elb.amazonaws.com:8080 -U kcfmaster1"
alias psql-connect-sdstage01="psql -h postgresql-stage.cluster-ro-c0qglu7wkpjn.us-east-1.rds.amazonaws.com -U kcfmaster1"
alias psql-connect-rw-sdstage01="psql -h postgresql-stage.cluster-c0qglu7wkpjn.us-east-1.rds.amazonaws.com -U kcfmaster1"
alias psql-connect-sdstage02="psql -h postgresql-stage.cluster-ro-cea65g4wjtsr.us-east-2.rds.amazonaws.com -U kcfmaster1"
alias psql-connect-sdstage02="psql -h postgresql-stage.cluster-cea65g4wjtsr.us-east-2.rds.amazonaws.com -U kcfmaster1"
alias psql-connect-prod01="psql -h postgresql-prod.cluster-ro-c5miretqxekw.us-east-1.rds.amazonaws.com -U kcfmaster1 -D prometheus"

alias c="pyc"
function pyc()
{
    python3 -c "from math import *; print($*)"
}
function pp_epoch()
{
    python3 <<EOF
import time;
if len("$1") == 10:
    print(time.strftime("%Y/%m/%d %H:%M:%S %Z", time.gmtime($1)))
elif len("$1") == 13:
    print(time.strftime("%Y/%m/%d %H:%M:%S.{} %Z".format($1%1000), time.gmtime($1/1000)))
else:
    print("Unexpected epoch length -- is this a valid unix epoch?")
EOF
}
function pp_local_epoch()
{
    python3 <<EOF
import time;
if len("$1") == 10:
    print(time.strftime("%Y/%m/%d %H:%M:%S %Z", time.localtime($1)))
elif len("$1") == 13:
    print(time.strftime("%Y/%m/%d %H:%M:%S.{} %Z".format($1%1000), time.localtime($1/1000)))
else:
    print("Unexpected epoch length -- is this a valid unix epoch?")
EOF
}

function unquote()
{
    sed "s/^\([\"']\)\(.*\)\1\$/\2/g"
}

function chirp()
{
    ( ( aplay /usr/local/share/audio/chirp.wav &&
        aplay /usr/local/share/audio/chirp.wav ) & ) > /dev/null 2>&1
}

function squawk()
{
    ( ( aplay /usr/local/share/audio/squawk.wav ) & ) > /dev/null 2>&1
}

function alert()
{
    local ret=$?
    if [[ $ret == 0 ]]; then
      chirp
    else
      squawk
    fi
    return $ret
}
alias p="alert"

function diffly () {
    /usr/bin/diff -w -y $@ -W $(( $(tput cols) - 9 )) | colordiff | less -r -RN
}

alias k2l="kcf2aws-login"
function k2c () {
    # Requires
    # - https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/
    # - https://addons.mozilla.org/en-US/firefox/addon/open-url-in-container/
    # - Phil's kcf2aws-login et al
    saml2aws console --idp-account $1 --profile $1 --link | xclip -i -r -selection c
    firefox "ext+container:name=${1}&url=https://duckduckgo.com"
}
