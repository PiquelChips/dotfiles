{ outputs, pkgs, ... }:
{
    default = pkgs.mkShell {
        buildInputs = [
            pkgs.zsh
            outputs.packages.${pkgs.stdenv.hostPlatform.system}.piquel-vim
        ];
        shellHook = "exec zsh";
    };
}
