#!/bin/bash

dotfiles="$HOME/dotfiles"
wallpaper_dir="$dotfiles/config/hypr/wallpaper"
files=($wallpaper_dir/*)

rm $dotfiles/config/hypr/hyprpaper.conf
touch $dotfiles/config/hypr/hyprpaper.conf

set_wallpaper() {

    random_file=("${files[RANDOM % ${#files[@]}]}")
    echo "preload=$random_file" >> $dotfiles/config/hypr/hyprpaper.conf
    echo "wallpaper=$1,$random_file" >> $dotfiles/config/hypr/hyprpaper.conf
}

set_wallpaper "DP-3"
set_wallpaper "HDMI-A-1"
