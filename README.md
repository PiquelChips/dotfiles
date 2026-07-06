# dotfiles
My dotfiles

## Setup machine

- ```nix-shell -p git --run "git clone https://github.com/PiquelChips/dotfiles ~"```
- ```sh dotfiles/setup.sh```

## Setup macOS

- Install Nix or Lix.
- Install Homebrew if you want nix-darwin to manage GUI casks.
- Clone this repo.
- Apply the Darwin configuration:

  ```sh
  sudo nix --extra-experimental-features "nix-command flakes" run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake .#mac
  ```

After the first switch, update with:

```sh
sudo darwin-rebuild switch --flake .#mac
```

## Install Vulkan-SDK

- Get the tarbal from the website
- Extract it in `/home/piquel/VulkanSDK`

## Left on Windows

- Microsoft 365
- Printing & Scanning

## Update

- Linux: `sudo nixos-rebuild switch --flake .#piquel --upgrade`
- macOS: `sudo darwin-rebuild switch --flake .#mac`
