{ inputs, ... }:
(inputs.import-tree [
  ./modules
  ./shells
  ./pkgs
  ./overlays
])
