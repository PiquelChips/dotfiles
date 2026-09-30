{ inputs, ... }:
let
  # Tailscale Serve terminates HTTPS on the tailnet and proxies to localhost.
  # Passkeys are bound to this origin: changing it invalidates every passkey.
  publicUrl = "https://nixosbtw.tailfcb6ab.ts.net";
in
{
  flake.nixosModules.piqueld = {
    imports = [ inputs.piqueld.nixosModules.default ];

    services.piqueld = {
      enable = true;
      settings = {
        server = {
          listen_mode = "localhost";
          port = 7846;
        };
        auth.public_url = publicUrl;
      };
    };

    # Development daemon (`just dev`) listens on Tailscale directly.
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 7845 ];

    users.users.piquel.extraGroups = [ "piqueld" ];

    programs.piquelctl.settings.profiles = {
      prod.socket = "/run/piqueld/piqueld.sock";
      dev.socket = "/tmp/piqueld-dev-run/piqueld.sock";
    };
  };

  flake.darwinModules.piqueld = {
    imports = [ inputs.piqueld.darwinModules.piquelctl ];

    programs.piquelctl = {
      enable = true;
      settings.profiles = {
        prod.url = publicUrl;
        dev.url = "http://nixosbtw.tailfcb6ab.ts.net:7845";
      };
    };
  };
}
