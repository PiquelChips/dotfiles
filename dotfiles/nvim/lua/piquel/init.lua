require("piquel.remap")
require("piquel.set")
require("piquel.lazy_init")

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {}, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {}, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end
})
