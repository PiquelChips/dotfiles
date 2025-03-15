#!/bin/sh

sudo nixos-rebuild switch --flake .
cd ~/dotfiles
stow config -t ~/.config
