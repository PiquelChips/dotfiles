{ lib, ... }:
{
    lsp = {
        inlayHints.enable = false;
        servers = {

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
                config.cmd = [ "clangd" "--clang-tidy" "--background-index" ];
            };

            denols = {
                enable = true;
                config.root_markers = [ "deno.lock" ];
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

    plugins = {
        fidget.enable = true;
        luasnip.enable = true;

        cmp = {
            enable = true;
            autoEnableSources = true;

            settings = {
                mapping = {
                    "<C-p>" = "cmp.mapping.select_prev_item()";
                    "<C-n>" = "cmp.mapping.select_next_item()";
                    "<C-y>" = "cmp.mapping.confirm({ select = true })";
                    "<C-Space>" = "cmp.mapping.complete()";
                };

                sources = [
                    { name = "nvim_lsp"; }
                    { name = "buffer"; }
                    { name = "path"; }
                    { name = "luasnip"; }
                ];
            };
        };

    };
}
