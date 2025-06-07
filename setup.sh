#!/bin/sh

cd ~/dotfiles
cp /etc/nixos/hardware-configuration.nix nix/
sudo nixos-rebuild switch --flake .#piquel
mkdir ~/.config
stow dotfiles -t ~/.config
