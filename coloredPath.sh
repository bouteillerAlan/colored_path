#!/usr/bin/env bash

declare -a hues=(
  "255 100 0" # orange
  "0 200 255" # blue
  "200 0 255" # purple
  "0 255 100" # green
  "255 0 100" # pink
  "255 255 0" # yellow
)

declare -a colors=(
  $'\e[38;5;226m' $'\e[38;5;220m'
  $'\e[38;5;214m' $'\e[38;5;208m'
  $'\e[38;5;202m' $'\e[38;5;166m'
  $'\e[38;5;130m'
)

getDegOfColors() {
  r1=$1 g1=$2 b1=$3
  r2=$4 g2=$5 b2=$6
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

  # Check for color support
  # -t 1 checks if stdout is a terminal
  # The ! -z "$FORCE_COLOR" part checks if the FORCE_COLOR variable is set
  if [ -t 1 ] || [ ! -z "$FORCE_COLOR" ]; then
    COLOR_SUPPORT=true
  else
    COLOR_SUPPORT=false
  fi

  IFS=":" read -ra paths <<< "$PATH"

  for path_idx in "${!paths[@]}"; do

    if [ "$COLOR_SUPPORT" = true ]; then
      hue_idx=$(( path_idx % ${#hues[@]} ))
      read -r hr hg hb <<< "${hues[$hue_idx]}"
      getDegOfColors 255 200 0 "$hr" "$hg" "$hb" 10
    fi

    IFS="/" read -ra parts <<< "${paths[$path_idx]}"
    color_idx=0

    for part_idx in "${!parts[@]}"; do

      # todo: refactor this part
      # skip empty line
      if [ -z "${parts[$part_idx]}" ]; then
        continue;
      fi

      if [ "$color_idx" -eq "${#colors[@]}" ]; then
        color_idx=$(( color_idx + 1 ))
      else
        color_idx=$(( (color_idx + 1) % ${#colors[@]} ))
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
