{ pkgs, ... }:
{
    plugins.treesitter = {
        enable = true;
        nixGrammars = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash json make regex xml yaml
            nix c cpp lua vim vimdoc
            query go sql css
            java javascript
            markdown svelte
        ];
        nixvimInjections = true;

        settings = {
            sync_install = false;
            auto_install = true;

            highlight = {
                enable = true;
                additional_vim_regex_highlighting = false;
            };

            incremental_selection = {
                enable = true;
                keymaps = {
                    init_selection = "<C-space>";
                    node_incremental = "<C-space>";
                    scope_incremental = "<C-s>";
                    node_decremental = "<C-backspace>";
                };
            };
        };
    };
}
