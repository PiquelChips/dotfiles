{ inputs, ... }:
{
  flake.nixosModules.secrets =
    { pkgs, ... }:
    let
      dir = ../../secrets;
    in
    {
      imports = [
        inputs.agenix.nixosModules.default
      ];

      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      age.secrets = {
        psswd.file = dir + /psswd.age;
        wifi-env = {
          file = dir + /wifi-env.age;
          mode = "0400";
        };
        # Root-only: systemd hands them to piqueld as credentials.
        piqueld-cloudflared-tunnel.file = dir + /piqueld-cloudflared-tunnel.age;
        piqueld-cloudflare-dns-token.file = dir + /piqueld-cloudflare-dns-token.age;
        piqueld-discord-webhook.file = dir + /piqueld-discord-webhook.age;
      };
    };
}
