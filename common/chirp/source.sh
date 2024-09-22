unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=linux;;
    Darwin*)    machine=osx;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    # MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

export CHIRP_DIR=$(cd $(dirname "${BASH_SOURCE[0]:-${(%):-%x}}") && pwd)

source ${CHIRP_DIR}/${machine}/chirp.sh
source ${CHIRP_DIR}/${machine}/squawk.sh
source ${CHIRP_DIR}/${machine}/alert.sh
