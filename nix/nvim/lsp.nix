{ lib, ... }:
{
    lsp = {
        keymaps = [
            { key = "gd"; mode = [ "n" ]; lspBufAction = "definition"; }
            { key = "gr"; mode = [ "n" ]; action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_references"; }
            { key = "gt"; mode = [ "n" ]; lspBufAction = "type_definition"; }
            { key = "gi"; mode = [ "n" ]; lspBufAction = "implementation"; }
            { key = "K";  mode = [ "n" ]; lspBufAction = "hover"; }
        ];
    };
}
