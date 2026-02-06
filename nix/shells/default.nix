{ outputs, pkgs, ... }:
{
    default = pkgs.mkShell {
        buildInputs = [
            pkgs.zsh
            outputs.packages.${pkgs.stdenv.hostPlatform.system}.nvim
        ];
        shellHook = "exec zsh";
    };
}
