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

            gopls.enable = true;
            bashls.enable = true;
            cssls.enable = true;
            dockerls.enable = true;
            jsonls.enable = true;
            lua_ls.enable = true;
            autotools_ls.enable = true;
            marksman.enable = true;
            tailwindcss.enable = true;
            svelte.enable = true;
            ts_ls.enable = true;
            jdtls.enable = true;
            nil_ls.enable = true;
            glsl_analyzer.enable = true;

            clangd = {
                enable = true;
                cmd = [
                    "clangd"
                    "--clang-tidy"
                    "--background-index"
                    "--query-driver=/etc/profiles/per-user/piquel/bin/g++,/etc/profiles/per-user/piquel/bin/gcc"
                ];
            };

            denols = {
                enable = true;
                root_markers = [ "deno.lock" ];
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
