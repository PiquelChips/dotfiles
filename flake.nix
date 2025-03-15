{
    description = "Piquel system configuration";
    
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
        piquel-cli = {
            url = "github:PiquelChips/piquel-cli";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { nixpkgs, ... } @ inputs: {
        nixosConfigurations.archbtw = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
                ./nix/default.nix
                ./nix/users/piquel/piquel.nix
            ];
        };
    };
}
