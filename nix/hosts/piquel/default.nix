{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.piquel = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.agent-tools
        self.nixosModules.nvim
        self.nixosModules.zsh
        self.nixosModules.tmux
        self.nixosModules.piquel-cli
        self.nixosModules.secrets
        # Do not add for now, wait for easy access to nightly
        # Before activating, make sure to move the state directory to the configured location
        #self.nixosModules.t3-code

        self.nixosModules.piquel
      ];
    };
    nixosModules.piquel =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        imports = [
          ./system.nix
        ];

        environment.etc."dotfiles-ghostty/config.ghostty".source = ../../../dotfiles/ghostty/config.ghostty;

        system.activationScripts.ghostty = lib.stringAfter [ "users" ] ''
          install -d -o piquel -g users /home/piquel/.config/ghostty
          ln -sfn /etc/dotfiles-ghostty/config.ghostty /home/piquel/.config/ghostty/config.ghostty
          chown -h piquel:users /home/piquel/.config/ghostty/config.ghostty
        '';

        users = {
          defaultUserShell = pkgs.zsh;
          users.piquel = {
            isNormalUser = true;
            extraGroups = [
              "networkmanager"
              "wheel"
              "docker"
            ]; # "scanner" "lp" ];
            shell = pkgs.zsh;
            packages = self.lib.dotfiles.commonPackages { inherit pkgs; };
            hashedPasswordFile = config.age.secrets.psswd.path;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHVqRluVYJXXoNYyFQzkZm2v2bRnAv/PNuoLRr2G2/Dv piquel@piquel.fr"
            ];
          };
        };

        nixpkgs = {
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "spotify"
              "jetbrains-toolbox"
              "discord"
              "discord-unwrapped"
              "steam"
              "steam-original"
              "steam-unwrapped"
              "steam-run"
              "obsidian"
            ];
        };

        programs = {
          hyprland = {
            enable = true;
            xwayland.enable = true;
          };
          hyprlock.enable = true;
          steam = {
            enable = true;
            gamescopeSession.enable = true;
            extest.enable = true;
            localNetworkGameTransfers.openFirewall = true;
          };
          xwayland.enable = true;
          nix-index = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = false;
            enableFishIntegration = false;
          };
          git = {
            enable = true;
            lfs.enable = true;
            config = self.lib.dotfiles.gitConfig;
          };
          appimage = {
            enable = true;
            binfmt = true;
          };
        };

        services = {
          openssh = {
            enable = true;
            settings = {
              UsePAM = false;
              PasswordAuthentication = false;
              PermitRootLogin = "no";
            };
          };
          flatpak.enable = true;
          hypridle.enable = true;
          locate = {
            enable = true;
            interval = "weekly";
          };
          tailscale.enable = true;
        };

        fonts = {
          enableDefaultPackages = true;
          packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
        };

        virtualisation.docker = {
          enable = true;
        };
      };
  };
}
