{ ... }:
{
    plugins.tmux-navigator = {
        enable = true;
        keymaps = [
            { key = "<C-h>"; action = "left"; }
            { key = "<C-j>"; action = "down"; }
            { key = "<C-k>"; action = "up"; }
            { key = "<C-l>"; action = "right"; }
        ];
    };
}
