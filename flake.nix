{
    description = "Piquel system configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
        systems.url = "github:nix-systems/default";
        flake-utils.url = "github:numtide/flake-utils";
        piquel-cli = {
            url = "github:PiquelChips/piquel-cli";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.flake-utils.follows = "flake-utils";
        };
        #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-raspberrypi = {
            url = "github:nvmd/nixos-raspberrypi/main";
            #inputs.nixpkgs.follows = "nixpkgs";
        };
        nixvim = {
            url = "github:nix-community/nixvim/nixos-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.systems.follows = "systems";
        };
    };

    nixConfig = {
        extra-substituters = [
            "https://nixos-raspberrypi.cachix.org"
        ];
        extra-trusted-public-keys = [
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        ];
    };

    outputs = { self, flake-utils, nixpkgs, nixos-raspberrypi, ... }@inputs:
    let
        inherit (self) outputs;
    in
    {
        nixosModules = import ./nix/modules;
        overlays = import ./nix/overlays { inherit inputs; };

        nixosConfigurations = {
            piquel = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs outputs; };
                modules = [ ./nix/configs/piquel ];
            };
            pi = nixos-raspberrypi.lib.nixosSystem {
                specialArgs = { inherit inputs outputs nixos-raspberrypi; };
                modules = [ ./nix/configs/pi ];
            };
        };
    } //
    flake-utils.lib.eachDefaultSystem (system:
    let
        inherit (self) outputs;
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        packages = import ./nix/pkgs { inherit inputs; } pkgs;
        devShells = import ./nix/shells { inherit pkgs outputs; };
        formatter = nixpkgs.legacyPackages.${system}.nixfmt;
    });
}
