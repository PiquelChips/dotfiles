{ inputs, self, ... }:
let
  macModule =
    {
      pkgs,
      lib,
      ...
    }:
    {
      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "obsidian"
          ];
      };

      nix = {
        gc = {
          automatic = true;
          options = "--delete-older-than 10d";
          interval = {
            Weekday = 0;
            Hour = 3;
            Minute = 15;
          };
        };
        optimise.automatic = true;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@admin"
            "ronan"
          ];
        };
      };

      users.users.ronan = {
        home = "/Users/ronan";
        shell = pkgs.zsh;
      };

      networking.hostName = "piquel-darwin";

      programs.zsh.enable = true;
      environment = {
        shells = [ pkgs.zsh ];
        variables = {
          LANG = "en_US.UTF-8";
          EDITOR = "vim";
          GIT_CONFIG_SYSTEM = "/etc/gitconfig";
        };
        systemPackages = self.lib.dotfiles.commonPackages { inherit pkgs; };
      };

      environment.etc."gitconfig".text = lib.generators.toGitINI self.lib.dotfiles.gitConfig;

      fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

      system = {
        activationScripts.postActivation.text = ''
          ln -sfn "/etc/gitconfig" "/Users/ronan/.gitconfig"
          chown -h ronan:staff "/Users/ronan/.gitconfig"

          mkdir -p "/Users/ronan/.config/ghostty"
          ln -sfn "/Users/ronan/dotfiles/dotfiles/ghostty/config.ghostty" "/Users/ronan/.config/ghostty/config.ghostty"
          chown -h ronan:staff "/Users/ronan/.config/ghostty/config.ghostty"

          mkdir -p "/Users/ronan/Library/Application Support/com.mitchellh.ghostty"
          ln -sfn "/Users/ronan/dotfiles/dotfiles/ghostty/config.ghostty" "/Users/ronan/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
          chown -h ronan:staff "/Users/ronan/Library/Application Support/com.mitchellh.ghostty/config.ghostty"

          mkdir -p "/Users/ronan/.config/aerospace"
          ln -sfn "/Users/ronan/dotfiles/dotfiles/aerospace/aerospace.toml" "/Users/ronan/.config/aerospace/aerospace.toml"
          chown -h ronan:staff "/Users/ronan/.config/aerospace/aerospace.toml"
        '';
        primaryUser = "ronan";
        stateVersion = 6;
        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };
        defaults = {
          dock.autohide = true;
          finder = {
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "Nlsv";
            ShowPathbar = true;
          };
          NSGlobalDomain = {
            ApplePressAndHoldEnabled = false;
            InitialKeyRepeat = 15;
            KeyRepeat = 2;
          };
        };
      };

      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        casks = [
          # Env
          "firefox"
          "raycast"
          "nikitabobko/tap/aerospace"

          # Dev
          "blender"
          "ghostty"
          "codex"
          "t3-code@nightly"

          # Games
          "steam"
          "heroic"

          "discord"
          "spotify"
        ];
      };

      # Temporary workaround for nix-darwin manual generation breakage with the
      # currently pinned nixpkgs/nixos-render-docs combination.
      documentation.enable = false;
      system.tools.darwin-uninstaller.enable = false;
    };
in
{
  flake.darwinConfigurations = {
    mac = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        self.darwinModules.nvim
        self.darwinModules.zsh
        self.darwinModules.tmux
        self.darwinModules.piquel-cli
        macModule
      ];
    };
  };
}
