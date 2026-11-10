{ ... }:
{
  # This machine builds piqueld's images once piqueld itself runs elsewhere
  # (sourceorigin-dev/piqueld#403). For now it only holds their registry.
  flake.nixosModules.build-machine =
    { config, lib, ... }:
    let
      port = 5000;
    in
    {
      # Stores the images built here. It listens on loopback only: the
      # tailnet reaches it through Tailscale Serve below, over HTTPS, and it
      # has no credentials, so the tailnet's access rules decide who may push
      # and pull.
      services.dockerRegistry = {
        enable = true;
        inherit port;
        # piqueld will delete the images no deployment uses any more; the
        # weekly garbage collection then frees their layers.
        enableDelete = true;
        enableGarbageCollect = true;
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
    };
}
