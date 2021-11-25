#!/usr/bin/env bash

DIR="$HOME/.config/polybar/grayblocks"

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -q bottom -c "$DIR"/config.ini &
