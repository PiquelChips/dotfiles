# Binary caches every build on this machine uses, beyond cache.nixos.org.
# deploy-rs builds a host's derivation directly, which skips a flake's own
# `nixConfig`, so the caches infra's hosts need are set here.
let
  settings = {
    extra-substituters = [
      # nixos-raspberrypi's kernels and firmware, for the Pi.
      "https://nixos-raspberrypi.cachix.org"
      # The Pi's own cache, on the tailnet: what nixosbtw has built
      # (the pi-cache-push module).
      "https://piquel-pi.tailfcb6ab.ts.net"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "piquel-pi-1:bKIz75gwV7RfJ6uT1YI+fUYbGk1uptOl9Vlu/jR+r0w="
    ];
    # While a cache is unreachable, such as the Pi off the tailnet, build
    # what it would have served instead of failing, and skip it for a
    # minute. Nix retries a connection that times out, so the short timeout
    # keeps that to about half a minute.
    fallback = true;
    connect-timeout = 5;
  };
in
{
  flake.nixosModules.binary-caches.nix.settings = settings;
  flake.darwinModules.binary-caches.nix.settings = settings;
}
