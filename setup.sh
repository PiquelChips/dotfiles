cd ~/dotfiles || exit
cp /etc/nixos/hardware-configuration.nix nix/hosts/piquel
sudo nixos-rebuild switch --flake .#piquel
rm -rf ~/.config/*
stow dotfiles -t ~/.config
