function chirp {
    (
        ( ( afplay "${CHIRP_DIR}/audio/chirp.wav" &) &&
          sleep .75 &&
          ( afplay "${CHIRP_DIR}/audio/chirp.wav" &) ) &
    ) > /dev/null 2>&1
}
