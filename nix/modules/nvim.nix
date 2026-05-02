{ ... }:
{
  flake.nixosModules.nvim =
    { inputs, ... }:
    {
      imports = [
        inputs.nixvim.nixosModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        imports = [
          ../nvim
          ../nvim/plugins/obsidian.nix
          ../nvim/lsp.nix
        ];
      };
    };
}
