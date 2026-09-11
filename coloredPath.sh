#!/usr/bin/env bash

# Check for color support
# -t 1 checks if stdout is a terminal
# The ! -z "$FORCE_COLOR" part checks if the FORCE_COLOR variable is set
if [ -t 1 ] || [ ! -z "$FORCE_COLOR" ]; then
  COLOR_SUPPORT=true
else
  COLOR_SUPPORT=false
fi

hues=(
  "255 100 000" # orange
  "000 200 255" # blue
  "200 000 255" # purple
  "000 255 100" # green
  "255 000 100" # pink
  "255 255 000" # yellow
)

colors=(
  $'\e[38;5;226m' $'\e[38;5;220m'
  $'\e[38;5;214m' $'\e[38;5;208m'
  $'\e[38;5;202m' $'\e[38;5;166m'
  $'\e[38;5;130m'
)

getDegOfColors() {
  r1=$1 g1=$2 b1=$3
  r2=$(( 255 - r1 ))
  g2=$(( 255 - g1 ))
  b2=$(( 255 - b1 ))
  steps=${7:-10}

  colors=()

  # lerp of the color
  for i in $steps; do
    r=$(( r1 + (r2 - r1) * i / (steps - 1) ))
    g=$(( g1 + (g2 - g1) * i / (steps - 1) ))
    b=$(( b1 + (b2 - b1) * i / (steps - 1) ))
    colors+=($'\e[38;2;'"${r};${g};${b}"'m')
  done
}

colorMyPath() {
  reset=$'\e[0m'
  colored=""
  hue_idx=0
  if [ "$COLOR_SUPPORT" = true ]; then
      colors=()
  fi

  IFS=":" read -ra paths <<< "$PATH"

  for path_idx in "${!paths[@]}"; do

    color_idx=0
    IFS="/" read -ra parts <<< "${paths[$path_idx]}"

    if [ "$COLOR_SUPPORT" = true ]; then
      selectedHue=${hues[$hue_idx]} # xxx xxx xxx
      r1=${selectedHue:0:3}
      g1=${selectedHue:4:3}
      b1=${selectedHue:8:3}
      if [[ "$r1" == "000" ]]; then
        r1=0
      fi
      if [[ "$g1" == "000" ]]; then
        g1=0
      fi
      if [[ "$b1" == "000" ]]; then
        b1=0
      fi
      r2=$(( 255 - r1 ))
      g2=$(( 255 - g1 ))
      b2=$(( 255 - b1 ))

      if [ "$hue_idx" -eq $(( ${#hues[@]} - 1 )) ]; then
        hue_idx=0
      else
        hue_idx=$(( hue_idx + 1 ))
      fi
    fi

    for part_idx in "${!parts[@]}"; do
      # skip empty part
      if [ -z "${parts[$part_idx]}" ]; then
        continue;
      fi

      if [ "$COLOR_SUPPORT" = true ]; then
        # interpolate color
        r=$(( $r1 + ($r2 - $r1) * $color_idx / (${#parts[@]} - 1) ))
        g=$(( $g1 + ($g2 - $g1) * $color_idx / (${#parts[@]} - 1) ))
        b=$(( $b1 + ($b2 - $b1) * $color_idx / (${#parts[@]} - 1) ))
        colors+=($'\e[38;2;'"${r};${g};${b}"'m')
      fi

      if [ "$color_idx" -eq $(( ${#colors[@]} - 1 )) ]; then
        color_idx=0
      else
        color_idx=$(( color_idx + 1 ))
      fi

      colored="${colored}/${colors[$color_idx]}${parts[$part_idx]}$reset"
    done

    if [ "$path_idx" -ne $(( ${#paths[@]} - 1 )) ]; then
      colored="${colored}:"
    fi
  done

  echo "$colored"
}
colorMyPath
