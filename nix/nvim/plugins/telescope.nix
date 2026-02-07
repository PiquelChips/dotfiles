{ ... }:
{
    plugins = {
        web-devicons.enable = true;
        telescope = {
            enable = true;

            settings = {
                defaults = {
                    file_ignore_patterns = [
                        "/Thirdparty/"
                        "Thirdparty/"
                        "^Thirdparty/"
                        "/thirdparty/"
                        "thirdparty/"
                        "^thirdparty/"
                    ];
                };
            };

            keymaps = {
                "<leader>pf" = {
                    action = "find_files";
                    options = {
                        desc = "Find files";
                    };
                };
                "<C-p>" = {
                    action = "git_files";
                    options = {
                        desc = "Git files";
                    };
                };
                "<leader>?" = {
                    action = "oldfiles";
                    options = {
                        desc = "[?] Find recently opened files";
                    };
                };
                "<leader><space>" = {
                    action = "buffers";
                    options = {
                        desc = "[ ] Find existing buffers";
                    };
                };
                "<leader>sw" = {
                    action = "lsp_workspace_symbols";
                    options = {
                        desc = "Workspace symbols";
                    };
                };
                "<leader>sd" = {
                    action = "lsp_document_symbols";
                    options = {
                        desc = "Document symbols";
                    };
                };
                "<leader>ps" = {
                    action = "live_grep";
                    options = {
                        desc = "Search by grep";
                    };
                };
            };
        };
    };

    # For the custom current_buffer_fuzzy_find with theme
    extraConfigLua = ''
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = "[/] Fuzzily search in current buffer" })
    '';
}
