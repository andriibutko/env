#!/usr/bin/env bash

direction=$1 # next (default) or prev

focused=$(yabai -m query --spaces --display | jq '.[] | select(."has-focus") | .index')

focus () {
    if [[ "$1" != "null" ]]; then
      yabai -m space --focus "$1";
      return 0
    else
      return 1
    fi
}

target () {
  echo "target" >&2
  rev=""
  cond=">"
  if [[ "$direction" == "prev" ]]; then
    echo "prev" >&2
    rev="| reverse"
    cond="<"
  fi

  target_impl "$cond" "$rev"
}

target_wrap () {
  echo "target_wrap" >&2
  rev=""
  cond="<"
  if [[ "$direction" == "prev" ]]; then
    echo "prev" >&2
    rev="| reverse"
    cond=">"
  fi

  target_impl "$cond" "$rev"
}


target_impl () {
  cond="$1"
  rev="$2"
  yabai -m query --spaces --display | jq "[.[] | select(.\"has-focus\" == false and .index $cond $focused and .windows != [])] $rev | .[0].index" | tee /dev/stderr
}

focus "$(target)" || focus "$(target_wrap)"

