function squawk {
    ( ( afplay "${CHIRP_DIR}/audio/squawk.wav" ) & ) > /dev/null 2>&1
}
