{ ... }:
{
    colorschemes.tokyonight = {
        enable = true;
        settings = {
            style = "storm";
            transparent = true;
            terminal_colors = true;
            styles = {
                comments = { italic = false; };
                keywords = { italic = false; };
                sidebars = "dark";
                floats = "dark";
            };
        };
    };
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
        nu = true;
        relativenumber = true;

        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        
        smartindent = true;
        
        wrap = false;
        
        hlsearch = false;
        incsearch = true;
        
        termguicolors = true;
        
        scrolloff = 8;
        signcolumn = "yes";
        
        updatetime = 50;
        
        colorcolumn = "80";
        
        mouse = "";

        # TODO
        # vim.opt.isfname:append("@-@")
        # vim.diagnostic.config({ virtual_text = true })
    };
}
