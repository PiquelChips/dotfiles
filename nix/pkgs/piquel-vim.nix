{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.piquel-vim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
        inherit pkgs;
        module = import ../nvim;
      };
    };
}
