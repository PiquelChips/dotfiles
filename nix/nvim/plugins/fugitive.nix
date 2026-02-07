{ ... }:
{
    plugins.fugitive.enable = true;

    keymaps = [
        {
            action = "<cmd>Git<cr>";
            key = "<leader>gs";
            mode = [ "n" ];
            options = {
                desc = "Git status";
            };
        }
    ];
}
