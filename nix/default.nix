{ inputs, ... }:
{
  imports = [
    (inputs.import-tree [
      ./modules
      ./shells
      ./pkgs
      ./overlays
    ])
  ];
}
