export CHIRP_DIR=$(cd $(dirname "${BASH_SOURCE[0]:-${(%):-%x}}") && pwd)

source ${CHIRP_DIR}/linux/chirp.sh
source ${CHIRP_DIR}/linux/squawk.sh
source ${CHIRP_DIR}/linux/alert.sh
