#!/bin/sh

cd ~/dotfiles
cp /etc/nixos/hardware-configuration.nix nix/
sudo nixos-rebuild switch --flake .
mkdir ~/.config
stow dotfiles -t ~/.config
