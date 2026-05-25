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
      };
    };
}
