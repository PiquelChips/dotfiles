{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.piquel-vim = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
        inherit pkgs;
        module = import ../nvim;
      };
    };
}
