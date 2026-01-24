return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",

        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        "j-hui/fidget.nvim",
    },

    config = function()
        local servers = {
            'clangd',
            'gopls',
            'bashls',
            'cssls',
            'dockerls',
            'jsonls',
            'lua_ls',
            'autotools_ls',
            'marksman',
            'tailwindcss',
            'svelte',
            'ts_ls',
            'denols',
            'jdtls',
            'nil_ls',
            'glsl_analyzer'
        }

        local cmp = require('cmp')
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        local handlers = {
            ["clangd"] = function(server_name)
                vim.lsp.config(server_name, {
                    capabilities = capabilities,
                    cmd = {
                        "clangd",
                        "--clang-tidy", -- Enable clang-tidy
                        "--background-index",
                        "--query-driver=/etc/profiles/per-user/piquel/bin/g++,/etc/profiles/per-user/piquel/bin/gcc",
                    },
                })
            end,
            ["denols"] = function(server_name)
                vim.lsp.config(server_name, {
                    capabilities = capabilities,
                    root_dir = function(bufnr, on_dir)
                        local root_markers = { 'deno.lock' }
                        -- Give the root markers equal priority by wrapping them in a table
                        root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
                            or vim.list_extend(root_markers, { '.git' })
                        local project_root = vim.fs.root(bufnr, root_markers)
                        -- We fallback to the current working directory if no project root is found
                        on_dir(project_root or vim.fn.getcwd())
                    end,
                })
            end,
        }

        local function default_handler(server_name)
            vim.lsp.config(server_name, { capabilities = capabilities })
        end

        for _, lsp in ipairs(servers) do
            local handler = handlers[lsp] or default_handler
            handler(lsp)
            vim.lsp.enable(lsp)
        end

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
            }, {
                { name = 'buffer' },
            })
        })
    end
}
