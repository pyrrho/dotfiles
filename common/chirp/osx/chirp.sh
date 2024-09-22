function chirp {
    ( ( afplay "${CHIRP_DIR}/audio/chirp.wav" &&
        afplay "${CHIRP_DIR}/audio/chirp.wav" ) & ) > /dev/null 2>&1
}
