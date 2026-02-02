{ inputs, config, pkgs, lib, ... }:
let
    cfg = config.services.piquel-cli;
in
{
    options.services.piquel-cli = {
        enable = lib.mkEnableOption "Tmux Configuration";

        package = lib.mkOption {
            type = lib.types.package;
            default = inputs.piquel-cli.packages.${pkgs.stdenv.hostPlatform.system}.default ;
            defaultText = lib.literalExpression "pkgs.piquel-cli";
            example = lib.literalExpression "pkgs.piquel-cli";
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];
    };
}
