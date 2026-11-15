{ ... }:
{
  # This machine builds the images of the piqueld running on ovh-1
  # (sourceorigin-dev/infra): a BuildKit daemon runs the builds and a registry
  # holds the images, which ovh-1 pulls.
  flake.nixosModules.build-machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      port = 5000;
      buildkitPort = 1234;
      # This machine's tailnet address and name, which ovh-1 reaches it by.
      tailnetAddress = "100.123.77.68";
      tailnetName = "nixosbtw.tailfcb6ab.ts.net";
    in
    {
      # Stores the images built here. It listens on loopback only: the
      # tailnet reaches it through Tailscale Serve below, over HTTPS, and it
      # has no credentials, so the tailnet's access rules decide who may push
      # and pull.
      services.dockerRegistry = {
        enable = true;
        inherit port;
        # piqueld will delete the images no deployment uses any more
        # (sourceorigin-dev/piqueld#409). Garbage collection, which frees
        # their layers, stays off until then: it restarts the registry, which
        # would fail a push in progress.
        enableDelete = true;
      };

      # Serves the registry at https://<this machine's tailnet name>:5000,
      # with the tailnet certificate Docker requires of a remote registry.
      # Serve keeps its configuration in tailscaled's state and each port is
      # its own entry, so this leaves other ports alone and running it again
      # changes nothing.
      systemd.services.registry-tailnet = {
        description = "Expose the image registry on the tailnet";
        after = [
          "tailscaled.service"
          "docker-registry.service"
        ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${lib.getExe config.services.tailscale.package} serve --bg --https=${toString port} http://127.0.0.1:${toString port}";
        };
      };

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
      # BuildKit pushes to the registry by its tailnet name, which this
      # machine's resolvers don't answer: Cloudflare's come first.
      networking.hosts.${tailnetAddress} = [ tailnetName ];
    };
}
