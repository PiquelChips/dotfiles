{ pkgs, ... }:
{
    plugins.treesitter = {
        enable = true;
        nixGrammars = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash json make regex xml yaml toml
            nix c cpp lua vim vimdoc
            query go sql css html
            java javascript typescript tsx
            markdown markdown_inline svelte
            diff d desktop dockerfile
            gitcommit gitignore glsl hyprlang ini rust
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
