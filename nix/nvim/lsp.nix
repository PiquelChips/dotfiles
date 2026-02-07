{ lib, ... }:
{
    lsp = {
        inlayHints.enable = true;
        servers = {
            "*" = {
                enable = true;
                config = {
                #     capabilities = {
                #         textDocument = {
                #             completion = {
                #                 completionItem = {
                #                     commitCharactersSupport = true;
                #                     deprecatedSupport = true;
                #                     insertReplaceSupport = true;
                #                     insertTextModeSupport = {
                #                         valueSet = [ 1 2 ];
                #                     };
                #                     labelDetailsSupport = true;
                #                     preselectSupport = true;
                #                     resolveSupport = {
                #                         properties = [ "documentation" "additionalTextEdits" "insertTextFormat" "insertTextMode" "command" ];
                #                     };
                #                     snippetSupport = true;
                #                     tagSupport = {
                #                         valueSet = [ 1 ];
                #                     };
                #                 };
                #                 completionList = {
                #                     itemDefaults = [ "commitCharacters" "editRange" "insertTextFormat" "insertTextMode" "data" ];
                #                 };
                #                 contextSupport = true;
                #                 dynamicRegistration = false;
                #                 insertTextMode = 1;
                #             };
                #         };
                #     };
                };
                root_markers = [
                    ".git"
                ];
            };
        };

        keymaps = [
            { key = "gd"; mode = [ "n" ]; lspBufAction = "definition"; }
            { key = "gr"; mode = [ "n" ]; action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_references"; }
            { key = "gt"; mode = [ "n" ]; lspBufAction = "type_definition"; }
            { key = "gi"; mode = [ "n" ]; lspBufAction = "implementation"; }
            { key = "K";  mode = [ "n" ]; lspBufAction = "hover"; }
        ];
    };
}
