{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.zsh
          self.packages.${pkgs.stdenv.hostPlatform.system}.piquel-vim
        ];
        shellHook = "exec zsh";
      };
    };
}
