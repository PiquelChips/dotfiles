{ lib, ... }:
{
    lsp = {
        keymaps = [
            { key = "gd"; lspBufAction = "definition"; }
            { key = "gr"; action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_references"; }
            { key = "gt"; lspBufAction = "type_definition"; }
            { key = "gi"; lspBufAction = "implementation"; }
            { key = "K"; lspBufAction = "hover"; }
        ];
    };
}
