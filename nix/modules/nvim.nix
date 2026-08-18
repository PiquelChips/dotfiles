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
        nixpkgs.source = inputs.nixpkgs;
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
        nixpkgs.source = inputs.nixpkgs;
        imports = [
          ../nvim
          ../nvim/lsp.nix
        ];
      };
    };
}
