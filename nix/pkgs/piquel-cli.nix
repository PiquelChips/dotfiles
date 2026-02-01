{ inputs, pkgs, ... }:
inputs.piquel-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
