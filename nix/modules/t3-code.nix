{ ... }:
{
  flake.nixosModules.t3-code =
    { pkgs, lib, ... }:
    let
      t3Code = pkgs.t3code;
      t3 = lib.getExe' t3Code "t3";
      stateDirectory = "/var/lib/t3-code-server";
      pairingHelper = pkgs.writeShellScriptBin "t3-server-pair" ''
        exec ${t3} pair --base-dir ${stateDirectory} "$@"
      '';
      connectHelper = pkgs.writeShellScriptBin "t3-server-connect" ''
        exec ${t3} connect link \
          --base-dir ${stateDirectory} \
          "$@"
      '';
    in
    {
      environment = {
        systemPackages = [
          t3Code
          pairingHelper
          connectHelper
        ];
      };

      systemd.services.t3-code-server = {
        description = "T3 Code headless server";
        documentation = [
          "https://github.com/pingdotgg/t3code/blob/main/docs/user/background-service.md"
        ];
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];

        path = [
          t3Code
          pkgs.codex
          pkgs.git
          pkgs.gh
          pkgs.openssh
          pkgs.zsh
        ];

        environment = {
          HOME = "/home/piquel";
          SHELL = lib.getExe pkgs.zsh;
        };

        serviceConfig = {
          User = "piquel";
          WorkingDirectory = "/home/piquel";
          StateDirectory = "t3-code-server";
          StateDirectoryMode = "0700";
          ExecStart = "${t3} serve --host 127.0.0.1 --port 3773 --base-dir ${stateDirectory}";
          Restart = "on-failure";
          RestartSec = 5;
          TimeoutStopSec = 30;
        };
      };
    };
}
