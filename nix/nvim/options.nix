{ ... }:
{
    vimAlias = true;
    enableMan = true;

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
    };

    diagnostic.settings.virtual_text = true;

    extraConfigLua = "vim.opt.isfname:append('@-@')";
}
