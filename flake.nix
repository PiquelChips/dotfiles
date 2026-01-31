{
    description = "Piquel system configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
        piquel-cli = {
            url = "github:PiquelChips/piquel-cli";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { nixpkgs, ... } @ inputs: 
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
                    ./nix/piquel.nix
                ];
            };
        };
    };
}
