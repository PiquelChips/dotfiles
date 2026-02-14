cd ~/dotfiles
cp /etc/nixos/hardware-configuration.nix nix/
sudo nixos-rebuild switch --flake .#piquel
rm -rf ~/.config/*
stow dotfiles -t ~/.config
