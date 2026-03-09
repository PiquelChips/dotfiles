{ ... }:
{
    opts.conceallevel = 1;
    plugins.obsidian = {
        enable = true;
        settings = {
            legacy_commands = false;
            workspaces = [
                {
                    name = "Piquel Vault";
                    path = "~/Documents/Obsidian/Piquel Vault/";
                }
            ];
        };

    };

    keymaps = [
        {
            action = "<cmd>Obsidian quick_switch<cr>";
            key = "<leader>o";
            mode = [ "n" ];
            options = {
                desc = "Obsidian quick switch";
            };
        }
    ];
}
