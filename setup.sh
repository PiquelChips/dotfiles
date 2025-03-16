#!/bin/sh

sudo nixos-rebuild switch --flake .
cd ~/dotfiles
stow dotfiles -t ~/.config
