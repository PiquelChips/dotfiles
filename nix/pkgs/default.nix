{ inputs, ... }:
pkgs: 
let
    system = pkgs.stdenv.hostPlatform.system;
in
{
    piquel-cli = inputs.piquel-cli.packages.${system}.default;
    piquel-vim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = import ../nvim;
    };
}
