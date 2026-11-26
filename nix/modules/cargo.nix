{ ... }:
let
  cargoConfig = ../../dotfiles/cargo/config.toml;

  # Links the global Cargo config into a user's home. ~/.cargo itself stays
  # writable, since Cargo keeps its registry, git checkouts & binaries there.
  linkScript =
    {
      home,
      user,
      group,
    }:
    ''
      install -d -o ${user} -g ${group} ${home}/.cargo
      ln -sfn /etc/dotfiles-cargo/config.toml ${home}/.cargo/config.toml
      chown -h ${user}:${group} ${home}/.cargo/config.toml
    '';
in
{
  flake.nixosModules.cargo =
    { lib, ... }:
    {
      environment.etc."dotfiles-cargo/config.toml".source = cargoConfig;

      system.activationScripts.cargo =
        lib.stringAfter
          [
            "users"
            "etc"
          ]
          (linkScript {
            home = "/home/piquel";
            user = "piquel";
            group = "users";
          });
    };

  flake.darwinModules.cargo =
    { ... }:
    {
      environment.etc."dotfiles-cargo/config.toml".source = cargoConfig;

      system.activationScripts.postActivation.text = linkScript {
        home = "/Users/ronan";
        user = "ronan";
        group = "staff";
      };
    };
}
