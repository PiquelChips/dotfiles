{
  description = "Piquel system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    piquel-cli = {
      url = "github:PiquelChips/piquel-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    piqueld = {
      url = "github:piquel-fr/piqueld";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      # TODO: fixup imports (use import-tree)
      # TODO: readd formatter
      imports = [
        ./nix/modules/zsh.nix
        ./nix/modules/nvim.nix
        ./nix/modules/tmux.nix
        ./nix/modules/piquel-cli.nix

        ./nix/shells/default.nix
        ./nix/hosts/piquel
        ./nix/overlays
        ./nix/pkgs/piquel-vim.nix
      ];
    };
}
