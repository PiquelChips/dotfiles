{
    description = "Piquel system configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
        piquel-cli = {
            url = "github:PiquelChips/piquel-cli";
            inputs.nixpkgs.follows = "nixpkgs";
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

    outputs = { nixpkgs, nixos-raspberrypi, ... } @ inputs: 
    let
        systems = [
            "x86_64-linux"
            "aarch64-linux"
            "aarch64-darwin"
        ];

        forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
        packages = forAllSystems (system: import ./nix/pkgs nixpkgs.legacyPackages.${system});

        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

        overlays = import ./nix/overlays {inherit inputs;};
        nixosModules = import ./nix/modules;

        nixosConfigurations = {
            piquel = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [
                    ./nix/configs/piquel
                ];
            };
            pi = nixos-raspberrypi.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [ ./nix/configs/pi ];
            };
        };
    };
}
