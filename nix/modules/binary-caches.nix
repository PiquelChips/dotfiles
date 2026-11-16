# Binary caches every build on this machine uses, beyond cache.nixos.org.
# deploy-rs builds a host's derivation directly, which skips a flake's own
# `nixConfig`, so the caches infra's hosts need are set here.
let
  settings = {
    # nixos-raspberrypi's kernels and firmware, for the Pi.
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
in
{
  flake.nixosModules.binary-caches.nix.settings = settings;
  flake.darwinModules.binary-caches.nix.settings = settings;
}
