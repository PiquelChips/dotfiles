{ inputs, ... }:
{
  imports = [
    inputs.piqueld.nixosModules.default
  ];

  services.piqueld = {
    enable = true;
    enableDaemon = true;
    group = "piqueld";
    daemonSettings = {
      data_dir = "/var/lib/piqueld";
      socket_path = "/run/piqueld/piqueld.sock";
      listen_addr = "0.0.0.0:7854";
    };
    # TODO: shouldn't be mandatory
    ctlSettings = {
      socket_path = "/run/piqueld/piqueld.sock";
      tcp_addr = "remote.piquel.fr:7854";
      default_to_tcp = true;
    };
  };
}
