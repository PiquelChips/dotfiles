{ inputs, lib, config, ... }:
let
    cfg = config.services.nvim;
in
{
    imports = [
        inputs.nixvim.nixosModules.nixvim
    ];

    options.services.nvim = {
        enable = lib.mkEnableOption "NeoVim Configuration";
    };

    config = lib.mkIf cfg.enable {
        programs.nixvim = {
            enable = true;
        };
    };
}
