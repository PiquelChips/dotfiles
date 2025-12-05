{
    description = "Piquel system configuration";
    
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
        piquel-cli = {
            url = "github:PiquelChips/piquel-cli";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { nixpkgs, ... } @ inputs: {
        nixosConfigurations."piquel" = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
                ./nix/users/piquel/piquel.nix
                ./nix/system.nix
            ];
        };
    };
}
