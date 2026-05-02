{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.zsh
          self.packages.${pkgs.system}.piquel-vim
        ];
        shellHook = "exec zsh";
      };
    };
}
