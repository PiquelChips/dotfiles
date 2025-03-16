#!/bin/bash

hyprdir="$HOME/.config/hypr"
wallpaper_dir="$hyprdir/wallpaper"
files=($wallpaper_dir/*)

rm $hyprdir/hyprpaper.conf

set_wallpaper() {

    random_file=("${files[RANDOM % ${#files[@]}]}")
    echo "preload=$random_file" >> $hyprdir/hyprpaper.conf
    echo "wallpaper=$1,$random_file" >> $hyprdir/hyprpaper.conf
}

set_wallpaper "DP-3"
set_wallpaper "HDMI-A-1"
