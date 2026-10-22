{ inputs, ... }:
let
  # piqueld joins the tailnet as its own node and serves HTTPS on it.
  # Passkeys are bound to this origin: changing it invalidates every passkey.
  publicUrl = "https://dash.piqueld.dev";
in
{
  flake.nixosModules.piqueld =
    { config, ... }:
    let
      secrets = config.age.secrets;
    in
    {
      imports = [ inputs.piqueld.nixosModules.default ];

      services.piqueld = {
        enable = true;
        settings = {
          auth = {
            max_token_days = 365;
          };
          tailscale = {
            enabled = true;
            hostname = "piqueld";
          };
          reconciliation.prepare_timeout_seconds = 1200;
          # Public routes arrive through a Cloudflare Tunnel (no open ports),
          # private routes through the piqueld-apps tailnet node, which logs
          # its login URL on first start.
          ingress = {
            enabled = true;
            acme.email = "admin@piquel.fr";
            private = {
              enabled = true;
              dashboard_hostname = "dash.piqueld.dev";
            };
            tunnel = {
              enabled = true;
              credentials_file = secrets.piqueld-cloudflared-tunnel.path;
            };
            webhook_hostname = "hooks.piqueld.dev";
          };
          # Issues private routes' DNS-01 certificates and manages every
          # route's records in the Cloudflare zones.
          dns.providers = [
            {
              kind = "cloudflare";
              api_token_file = secrets.piqueld-cloudflare-dns-token.path;
              manage_records = true;
            }
          ];
        };
      };

      users.users.piquel.extraGroups = [ "piqueld" ];

      programs.piquelctl.settings.profiles.prod.socket = "/run/piqueld/piqueld.sock";
    };

  flake.darwinModules.piqueld = {
    imports = [ inputs.piqueld.darwinModules.piquelctl ];

    programs.piquelctl = {
      enable = true;
      settings.profiles.prod.url = publicUrl;
    };
  };
}
