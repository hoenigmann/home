#!/usr/bin/env bash
xsetroot -solid black

[ -e ~/.Xmodmap ] && xmodmap ~/.Xmodmap
xterm -e screen -R &
exec ratpoison
