#!/usr/bin/env bash

# Check for color support
# -t 1 checks if stdout is a terminal
# The ! -z "$FORCE_COLOR" part checks if the FORCE_COLOR variable is set
if [ -t 1 ] || [ ! -z "$FORCE_COLOR" ]; then
  COLOR_SUPPORT=true
else
  COLOR_SUPPORT=false
fi

colorMyPath() {
  hues=(
    "255 100 000 255 180 000" # orange → light orange
    "000 200 255 120 230 255" # blue → light blue
    "200 000 255 230 120 255" # purple → light purple
    "000 255 100 120 255 170" # green → light green
    "255 000 100 255 120 180" # pink → light pink
    "255 255 000 255 255 150" # yellow → light yellow
  )
  colors=(
    $'\e[38;5;226m' $'\e[38;5;220m'
    $'\e[38;5;214m' $'\e[38;5;208m'
    $'\e[38;5;202m' $'\e[38;5;166m'
    $'\e[38;5;130m'
  )

  colored=""
  hue_idx=0
  reset=$'\e[0m'

  if [ "$COLOR_SUPPORT" = true ]; then
      colors=()
  fi

  IFS=":" read -ra paths <<< "$PATH"

  for path_idx in "${!paths[@]}"; do
    color_idx=0
    hasEmpty=false
    IFS="/" read -ra parts <<< "${paths[$path_idx]}"

    if [ "$COLOR_SUPPORT" = true ]; then
      selectedHue=${hues[$hue_idx]}

      r1=${selectedHue:0:3}
      r2=${selectedHue:4:3}

      g1=${selectedHue:8:3}
      g2=${selectedHue:12:3}

      b1=${selectedHue:16:3}
      b2=${selectedHue:20:3}

      if [[ "$r1" == "000" ]]; then
        r1=0
      fi
      if [[ "$g1" == "000" ]]; then
        g1=0
      fi
      if [[ "$b1" == "000" ]]; then
        b1=0
      fi
      if [[ "$r2" == "000" ]]; then
        r2=0
      fi
      if [[ "$g2" == "000" ]]; then
        g2=0
      fi
      if [[ "$b2" == "000" ]]; then
        b2=0
      fi

      if [ "$hue_idx" -eq $(( ${#hues[@]} - 1 )) ]; then
        hue_idx=0
      else
        hue_idx=$(( hue_idx + 1 ))
      fi
    fi

    for part_idx in "${!parts[@]}"; do
      # skip empty part
      if [ -z "${parts[$part_idx]}" ]; then
        hasEmpty=true
        continue;
      fi

      l=${#parts[@]}
      if [ "$hasEmpty" = true ]; then
        l=$(( l - 1 ))
      fi

      if [ "$COLOR_SUPPORT" = true ]; then
        # interpolate color
        r=$(( $r1 + ($r2 - $r1) * $color_idx / ($l - 1) ))
        g=$(( $g1 + ($g2 - $g1) * $color_idx / ($l - 1) ))
        b=$(( $b1 + ($b2 - $b1) * $color_idx / ($l - 1) ))
        colors+=($'\e[38;2;'"${r};${g};${b}"'m')
      fi

      colored="${colored}/${colors[$color_idx]}${parts[$part_idx]}$reset"

      if [ "$color_idx" -eq $(( ${#colors[@]} - 1 )) ]; then
        color_idx=0
      else
        color_idx=$(( color_idx + 1 ))
      fi
    done

    if [ "$path_idx" -ne $(( ${#paths[@]} - 1 )) ]; then
      colored="${colored}:"
    fi

    hasEmpty= false
    colors=()
  done

  echo "$colored"
}
colorMyPath
