# dotfiles
My dotfiles

## Setup machine

- ```nix-shell -p git --run "git clone https://github.com/PiquelChips/dotfiles ~"```
- ```sh dotfiles/setup.sh```

## Install Vulkan-SDK

- Get the tarbal from the website
- Extract it in `/home/piquel/VulkanSDK`

## Left on Windows

- Microsoft 365
- Printing & Scanning

## Update

- Machine: `sudo nixos-rebuild switch --flake .#piquel --upgrade`
- RaspberryPi: `nixos-rebuild switch --flake .#pi --target-host piquel@remote.piquel.fr --sudo --ask-sudo-password`
