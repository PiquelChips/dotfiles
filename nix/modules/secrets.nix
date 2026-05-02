{ inputs, ... }:
{
  flake.nixosModules.secrets =
    { pkgs, ... }:
    {
      imports = [
        inputs.agenix.nixosModules.default
      ];

      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
