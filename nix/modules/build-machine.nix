{ inputs, ... }:
{
  # This machine builds the images of the piqueld running on ovh-1
  # (sourceorigin-dev/infra), with piqueld's build machine module: a rootless
  # BuildKit daemon, served on this machine's tailnet name at port 1234, runs
  # the builds and pushes the images to piquel-pi's registry (also in
  # sourceorigin-dev/infra), which ovh-1 pulls from, so they stay available
  # while this machine is off.
  flake.nixosModules.build-machine = {
    imports = [ inputs.piqueld.nixosModules.piqueld-builder ];

    services.piqueld-builder = {
      enable = true;
      # Room to keep the layers of all of ovh-1's applications cached.
      cacheSize = "100GB";
    };

    # BuildKit pushes to the Pi's registry by its tailnet name. Pushes failed
    # with `no such host` while Cloudflare's resolvers came before
    # Tailscale's (#39), so the name doesn't depend on their order. BuildKit
    # sees this through its copy of /etc.
    networking.hosts."100.96.91.58" = [ "piquel-pi.tailfcb6ab.ts.net" ];
  };
}
