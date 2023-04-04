function chirp {
    ( ( aplay "${CHIRP_DIR}/audio/chirp.wav" &&
        aplay "${CHIRP_DIR}/audio/chirp.wav" ) & ) > /dev/null 2>&1
}
