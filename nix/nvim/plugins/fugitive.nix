{ lib, pkgs, ... }:
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

  extraConfigLua = lib.optionalString pkgs.stdenv.isDarwin ''
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "fugitive",
        callback = function(event)
            vim.keymap.set("n", "-", "=", {
                buffer = event.buf,
                remap = true,
                desc = "Fugitive expand diff",
            })
        end,
    })
  '';
}
