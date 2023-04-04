src_dir=$(cd $(dirname "${BASH_SOURCE[0]:-${(%):-%x}}") && pwd)
export CHIRP_DIR="${src_dir}/chirp"

source ${CHIRP_DIR}/linux/chirp.sh
source ${CHIRP_DIR}/linux/squawk.sh
source ${CHIRP_DIR}/linux/alert.sh
