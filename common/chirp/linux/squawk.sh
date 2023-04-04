function squawk {
    ( ( aplay "${CHIRP_DIR}/audio/squawk.wav" ) & ) > /dev/null 2>&1
}
