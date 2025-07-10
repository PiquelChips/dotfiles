return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                -- layout_strategy = "horizontal",
                -- layout_config = { prompt_position = "top" },
                -- sorting_strategy = "ascending",
                -- winblend = 0,
                file_ignore_patterns = { "/thirdparty/", "thirdparty/", "^thirdparty/" },
            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = "[?] Find recently opened files" })
        vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = "[ ] Find existing buffers" })
        vim.keymap.set('n', '<leader>sw', builtin.lsp_workspace_symbols, {}, opts)
        vim.keymap.set('n', '<leader>sd', builtin.lsp_document_symbols, {}, opts)
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = "[/] Fuzzily search in current buffer" })
        vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Search by grep' })
    end
}
