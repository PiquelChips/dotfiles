{ inputs, ... }:
{
  flake.nixosModules.piqueld = {
    imports = [ inputs.piqueld.nixosModules.default ];

    services.piqueld = {
      enable = true;
      settings.server = {
        listen_mode = "localhost";
        port = 7846;
      };
    };

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
        prod.url = "https://nixosbtw.tailfcb6ab.ts.net:8443";
        dev.url = "https://nixosbtw.tailfcb6ab.ts.net";
      };
    };
  };
}
