{ inputs, ... }:
{
  flake.nixosModules.nvim =
    { ... }:
    {
      imports = [
        inputs.nixvim.nixosModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        imports = [
          ../nvim
          ../nvim/lsp.nix
        ];
      };
    };

  flake.darwinModules.nvim =
    { ... }:
    {
      imports = [
        inputs.nixvim.nixDarwinModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        imports = [
          ../nvim
          ../nvim/lsp.nix
        ];
      };
    };
}
