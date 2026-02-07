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
        lsp = lib.mkEnableOption "Enable LSP";
    };

    config = lib.mkIf cfg.enable {
        programs.nixvim = {
            enable = true;
            defaultEditor = true;
            imports = [ ../nvim ] ++ lib.optional cfg.lsp ../nvim/lsp.nix;
        };
    };
}
