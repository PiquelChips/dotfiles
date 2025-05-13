return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup {
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "cpp", "sql", "css", "java", "javascript", "markdown" },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<C-space>',
                    node_incremental = '<C-space>',
                    scope_incremental = '<C-s>',
                    node_decremental = '<c-backspace>',
                },
            },
        }
    end
}
