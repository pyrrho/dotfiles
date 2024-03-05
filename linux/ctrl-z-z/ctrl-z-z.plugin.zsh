ctrl-z-z () {
  if [[ ! $#BUFFER -eq 0 ]]; then
    zle push-input
  fi
  BUFFER="fg"
  zle accept-line
}

zle -N ctrl-z-z
bindkey '^Z' ctrl-z-z
