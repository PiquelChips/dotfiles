{ ... }:
{
    globals.mapleader = " ";

    keymaps = [
        { mode = "n"; key = "<leader>pv"; action = "<cmd>Ex<cr>"; options.desc = "Open file explorer"; }
        { mode = [ "i" "n" "v" ]; key = "<C-C>"; action = "<esc>"; }
        { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; options.desc = "Move line down"; }
        { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; options.desc = "Move line up"; }
        { mode = "n"; key = "J"; action = "mzJ`z"; options.desc = "Join lines"; }
        { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; options.desc = "Scroll down and center"; }
        { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; options.desc = "Scroll up and center"; }
        { mode = "n"; key = "n"; action = "nzzzv"; options.desc = "Next search result"; }
        { mode = "n"; key = "N"; action = "Nzzzv"; options.desc = "Previous search result"; }
        # Greatest remap ever
        { mode = "x"; key = "<leader>p"; action = ''"_dP''; options.desc = "Paste without yanking"; }
        # Next greatest remap ever
        { mode = [ "n" "v" ]; key = "<leader>y"; action = ''"+y''; options.desc = "Yank to system clipboard"; }
        { mode = "n"; key = "<leader>Y"; action = ''"+Y''; options.desc = "Yank line to system clipboard"; }
        { mode = [ "n" "v" ]; key = "<leader>d"; action = ''"_d''; options.desc = "Delete without yanking"; }
        { mode = "n"; key = "<leader>f"; action.__raw = "vim.lsp.buf.format"; options.desc = "Format buffer"; }
        { mode = "n"; key = "<leader>s"; action = '':%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>''; options.desc = "Search and replace word under cursor"; }
        { mode = "n"; key = "<leader>x"; action = "<cmd>!chmod +x %<CR>"; options = { silent = true; desc = "Make file executable"; }; }
        # Nav panes
        { mode = "n"; key = "<C-k>"; action = "<cmd>wincmd k<CR>"; options.desc = "Move to window above"; }
        { mode = "n"; key = "<C-j>"; action = "<cmd>wincmd j<CR>"; options.desc = "Move to window below"; }
        { mode = "n"; key = "<C-h>"; action = "<cmd>wincmd h<CR>"; options.desc = "Move to window left"; }
        { mode = "n"; key = "<C-l>"; action = "<cmd>wincmd l<CR>"; options.desc = "Move to window right"; }
    ];
}
