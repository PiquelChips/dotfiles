{ inputs, ... }:
{
  imports = [
    inputs.piqueld.nixosModules.default
  ];

  services.piqueld = {
    enable = true;
    enableDaemon = true;
  };
}
