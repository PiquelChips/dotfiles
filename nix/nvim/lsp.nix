{ pkgs, lib, ... }:
{
    lsp = {
        inlayHints.enable = false;
        servers = {
            gopls.enable = true;
            rust_analyzer = {
                enable = true;
                config = {
                    # Rust analyzer uses one target per Cargo workspace. Index the
                    # dashboard's workspace as WASM so cfg-gated UI modules are active.
                    before_init = lib.nixvim.mkRaw ''
                        function(params, config)
                            local settings = config.settings["rust-analyzer"]
                            local root = config.root_dir
                            if root and vim.fn.filereadable(root .. "/apps/piqueld-ui/Cargo.toml") == 1 then
                                settings.cargo.target = "wasm32-unknown-unknown"
                                settings.check = { workspace = false }
                            end
                            -- Keep nvim-lspconfig's initialization and command handler.
                            local defaults = dofile(vim.api.nvim_get_runtime_file("lsp/rust_analyzer.lua", false)[1])
                            defaults.before_init(params, config)
                        end
                    '';
                    settings = {
                        "rust-analyzer" = {
                            cargo.allFeatures = true;
                        };
                    };
                };
            };
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
            glsl_analyzer.enable = true;

            clangd = {
                enable = true;
                config.cmd = [ "clangd" "--clang-tidy" "--background-index" ];
            };

            denols = {
                enable = true;
                config.root_markers = [ "deno.lock" ];
            };

            nixd = {
                enable = true;
                config =
                let
                    flake = ''(builtins.getFlake "github:PiquelChips/dotfiles)""'';
                in
                {
                    nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
                    formatting.command = [ "${lib.getExe pkgs.nixfmt}" "--indent=4" ];
                    options.nixos.expr = ''${flake}.nixosConfigurations.piquel.options'';
                };
            };
        };

        keymaps = [
            { key = "gd"; mode = [ "n" ]; action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions"; }
            { key = "gr"; mode = [ "n" ]; action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_references"; }
            { key = "gt"; mode = [ "n" ]; lspBufAction = "type_definition"; }
            { key = "gi"; mode = [ "n" ]; lspBufAction = "implementation"; }
            { key = "K";  mode = [ "n" ]; lspBufAction = "hover"; }
        ];
    };

    plugins = {
        lspconfig.enable = true;
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
