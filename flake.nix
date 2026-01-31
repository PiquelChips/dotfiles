{
    description = "Piquel system configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
        flake-utils.url = "github:numtide/flake-utils";
        piquel-cli = {
            url = "github:PiquelChips/piquel-cli";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.flake-utils.follows = "flake-utils";
        };
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    };
    
    nixConfig = {
        extra-substituters = [
            "https://nixos-raspberrypi.cachix.org"
        ];
        extra-trusted-public-keys = [
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        ];
    };

    outputs = { self, flake-utils, nixpkgs, nixos-raspberrypi, ... } @ inputs:
    let 
        inherit (self) outputs;
    in{
        packages = flake-utils.lib.eachDefaultSystem (system: import ./nix/pkgs nixpkgs.legacyPackages.${system});

        formatter = flake-utils.lib.eachDefaultSystem (system: nixpkgs.legacyPackages.${system}.nixfmt);

        overlays = import ./nix/overlays {inherit inputs;};
        nixosModules = import ./nix/modules;

        nixosConfigurations = {
            piquel = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs outputs; };
                modules = [
                    ./nix/configs/piquel
                ];
            };
            pi = nixos-raspberrypi.lib.nixosSystem {
                specialArgs = { inherit nixos-raspberrypi outputs; };
                modules = [ ./nix/configs/pi ];
            };
        };
    };
}
