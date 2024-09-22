function alert {
    local ret=${?}
    if [[ $ret == 0 ]]; then
        chirp
    else
        squawk
    fi
    return ${ret}
}

alias p="alert"
