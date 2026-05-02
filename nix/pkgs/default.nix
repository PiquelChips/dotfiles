{
  perSystem =
    { pkgs, inputs', ... }:
    {
      packages = {
        piquel-vim = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
          inherit pkgs;
          module = import ../nvim;
        };
      };
    };
}
