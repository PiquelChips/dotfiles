{ inputs, ... }:
let
  settings = {
    projects_dir = "~/Projects";
    default_session = "default";

    machines = [
      {
        name = "nixosbtw";
        address = "nixosbtw";
        username = "piquel";
      }
      {
        name = "pi";
        address = "piquel-pi";
        username = "piquel";
      }
      {
        name = "vps";
        address = "piquel.fr";
        username = "piquel";
      }
    ];

    sessions = {
      default = {
        windows = [
          { commands = [ "vim ." ]; }
          { commands = [ "git pull" ]; }
        ];
      };
      rust = {
        windows = [
          { commands = [ "vim ." ]; }
          {
            commands = [
              "git pull"
              "cargo clippy"
            ];
          }
        ];
      };
    };

    projects = [
      {
        repository = "git@github.com:PiquelChips/dotfiles.git";
        path = "~/dotfiles";
        default_session = {
          windows = [
            { commands = [ "vim ." ]; }
            {
              commands = [
                "git pull"
                "nix flake update"
                "sudo nixos-rebuild switch --flake .#piquel --upgrade"
              ];
            }
          ];
        };
      }
      {
        repository = "git@github.com:piquel-fr/infra";
        default_session = {
          windows = [
            { commands = [ "vim ." ]; }
            {
              commands = [
                "git pull"
                "nix flake update"
              ];
            }
            { commands = [ "ssh piquel@remote.piquel.fr" ]; }
          ];
        };
      }
      {
        repository = "git@github.com:piquel-fr/vps-setup";
        default_session = {
          windows = [
            { commands = [ "vim ." ]; }
            {
              commands = [
                "git pull"
                "docker --context default compose up -d"
              ];
            }
            { commands = [ "ssh piquel@piquel.fr" ]; }
          ];
        };
      }
      {
        repository = "git@github.com:piquel-fr/piquel-fr";
        default_session = "rust";
      }
      {
        repository = "git@github.com:piquel-fr/website.git";
        name = "piquel-web";
        default_session = {
          windows = [
            { commands = [ "vim ." ]; }
            { commands = [ "git pull" ]; }
            {
              commands = [
                "deno install"
                "deno task dev"
              ];
            }
          ];
        };
      }
      {
        repository = "git@github.com:piquel-fr/api.git";
        name = "piquel-api";
        default_session = {
          windows = [
            { commands = [ "vim ." ]; }
            { commands = [ "git pull" ]; }
            { commands = [ "air" ]; }
          ];
        };
      }
      {
        repository = "git@github.com:piquel-fr/piqueld.git";
        name = "piqueld";
        path = "~/Projects/piqueld";
        default_session = {
          windows = [
            { commands = [ "vim ." ]; }
            {
              commands = [
                "git pull"
                "cargo run --bin piquelctl"
              ];
            }
            { commands = [ "cargo watch -x 'run --bin piqueld -- -v --config ./test/config.toml'" ]; }
          ];
        };
      }
      {
        repository = "git@github.com:PiquelChips/piquel-cli.git";
        default_session = "rust";
      }
      {
        repository = "git@github.com:piquel-fr/piquel-log.git";
        default_session = "rust";
      }
      {
        repository = "file:///home/piquel/Projects/Hytale";
        name = "hytale";
        path = "~/Projects/Hytale";
        default_session = {
          windows = [
            {
              commands = [
                "cd HytalePlugin"
                "git pull"
                "vim ."
              ];
            }
            {
              commands = [
                "cd HytalePlugin"
                "./gradlew build"
              ];
            }
            {
              commands = [
                "flatpak --user run com.hypixel.HytaleLauncher"
                "cd Config"
                "vim ."
              ];
            }
            {
              commands = [
                "cd Server"
                "java -jar HytaleServer.jar --assets ../Assets.zip"
              ];
            }
          ];
        };
      }
      {
        repository = "git@github.com:bevyengine/bevy.git";
        default_session = "rust";
      }
      {
        repository = "git@github.com:DirkEngine/DirkEngine.git";
        name = "dirkengine";
        path = "~/Projects/DirkEngine";
        default_session = "rust";
      }
      {
        repository = "git@github.com:PiquelChips/Homework.git";
        name = "homework";
        path = "~/homework";
        default_session = "default";
      }
      {
        repository = "file:///home/piquel/Projects/OpenMC";
        name = "openmc";
        path = "~/Projects/OpenMC";
        default_session = {
          windows = [
            {
              commands = [
                "cd PluginV2"
                "vim ."
              ];
            }
            {
              commands = [
                "cd PluginV2"
                "git pull"
                "./gradlew shadowJar"
              ];
            }
            {
              commands = [
                "cd ItemsAdder"
                "git pull"
                "cd ../Server"
                "vim ."
              ];
            }
            {
              commands = [
                "cd Server"
                "./start.sh"
              ];
            }
          ];
        };
      }
      {
        repository = "git@github.com:pingdotgg/t3code";
        default_session = {
          windows = [
            { commands = [ "vim ." ]; }
            {
              commands = [
                "git pull"
                "pnpm run dist:desktop:linux"
                "pnpm run start:desktop"
              ];
            }
          ];
        };
      }
    ];
  };
in
{
  flake.nixosModules.piquel-cli =
    { ... }:
    {
      imports = [
        inputs.piquel-cli.nixosModules.default
      ];

      programs.piquelcli = {
        enable = true;
        inherit settings;
      };
    };

  flake.darwinModules.piquel-cli =
    { ... }:
    {
      imports = [
        inputs.piquel-cli.nixosModules.default
      ];

      programs.piquelcli = {
        enable = true;
        inherit settings;
      };
    };
}
