{ pkgs, outputs, config, lib, ... }:
let
    cfg = config.services.piquel-cli;
in
{
    options.services.piquel-cli = {
        enable = lib.mkEnableOption "Tmux Configuration";

        package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.piquel-cli;
            defaultText = lib.literalExpression "pkgs.piquel-cli";
            example = lib.literalExpression "pkgs.piquel-cli";
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];
    };
}
