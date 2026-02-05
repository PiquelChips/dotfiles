{ inputs, ... }:
pkgs: {
    piquel-cli = inputs.piquel-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;
}
