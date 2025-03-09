#!/bin/sh

cd ~
# Set the main nixos configuration file
sudo echo "{ ... }:{ imports = [ ./hardware-configuration.nix $HOME/dotfiles/nix/default.nix ]; }" > /etc/nixos/configuration.nix
sudo nixos-rebuild switch
stow dotfiles/config -t ~/.config
