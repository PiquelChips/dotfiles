{ ... }:
{
  # This machine builds the images of the piqueld running on ovh-1
  # (sourceorigin-dev/infra): a BuildKit daemon runs the builds and pushes the
  # images to piquel-pi's registry (also in sourceorigin-dev/infra), which
  # ovh-1 pulls from, so they stay available while this machine is off.
  flake.nixosModules.build-machine =
    { pkgs, ... }:
    let
      buildkitPort = 1234;
      # This machine's tailnet address, which ovh-1 reaches BuildKit at.
      tailnetAddress = "100.123.77.68";
    in
    {
      # Runs the builds ovh-1's piqueld sends. It runs any build it's sent,
      # without credentials, so it listens on the tailnet only, and the
      # tailnet's access rules should limit it to ovh-1.
      systemd.services.buildkitd = {
        description = "BuildKit daemon for piqueld's builds";
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.runc ];
        serviceConfig = {
          ExecStart = "${pkgs.buildkit}/bin/buildkitd --addr tcp://${tailnetAddress}:${toString buildkitPort}";
          # Its address only exists once tailscaled is up.
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ buildkitPort ];
      # BuildKit pushes to the Pi's registry by its tailnet name, which this
      # machine's resolvers don't answer: Cloudflare's come first.
      networking.hosts."100.96.91.58" = [ "piquel-pi.tailfcb6ab.ts.net" ];
    };
}
