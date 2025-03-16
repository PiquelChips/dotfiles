require("piquel.remap")
require("piquel.set")
require("piquel.lazy_init")

local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {}, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {}, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').lsp_workspace_symbols, {}, opts)
        vim.keymap.set('n', '<leader>sd', require('telescope.builtin').lsp_document_symbols, {}, opts)

    end
})
