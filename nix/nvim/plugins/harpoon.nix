{ ... }:
{
    plugins.harpoon = {
        enable = true;
        enableTelescope = true;
    };

    keymaps = [
        { mode = "n"; key = "<leader>a"; action.__raw = "function() require'harpoon':list():add() end"; }
        { mode = "n"; key = "<C-e>"; action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end"; }
        { mode = "n"; key = "<C-j>"; action.__raw = "function() require'harpoon':list():select(1) end"; }
        { mode = "n"; key = "<C-k>"; action.__raw = "function() require'harpoon':list():select(2) end"; }
        { mode = "n"; key = "<C-l>"; action.__raw = "function() require'harpoon':list():select(3) end"; }
        { mode = "n"; key = "<C-m>"; action.__raw = "function() require'harpoon':list():select(4) end"; }
    ];

    extraConfigLua = ''
        local harpoon = require("harpoon")
        vim.keymap.set("n", "<leader><M-j>", function() harpoon:list():replace_at(1) end)
        vim.keymap.set("n", "<leader><M-k>", function() harpoon:list():replace_at(2) end)
        vim.keymap.set("n", "<leader><M-l>", function() harpoon:list():replace_at(3) end)
        vim.keymap.set("n", "<leader><M-m>", function() harpoon:list():replace_at(4) end)
    '';
}
