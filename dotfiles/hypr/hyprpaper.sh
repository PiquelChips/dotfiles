#!/bin/bash

hyprdir="$HOME/.config/hypr"
hyprconf="$hyprdir/hyprpaper.conf"

wallpaper_dir="$hyprdir/wallpaper"
files=($wallpaper_dir/*)

rm $hyprdir/hyprpaper.conf


set_wallpaper() {

    random_file=("${files[RANDOM % ${#files[@]}]}")
    echo "wallpaper {" >> "$hyprconf"
    echo "    monitor = $1" >> "$hyprconf"
    echo "    path = $random_file" >> "$hyprconf"
    echo "    fit_mode = cover" >> "$hyprconf"
    echo "}" >> "$hyprconf"
    echo "" >> "$hyprconf"

}

set_wallpaper "DP-3"
set_wallpaper "HDMI-A-1"
