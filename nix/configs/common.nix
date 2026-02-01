{ outputs, pkgs, ... }:
{
    networking = {
        networkmanager.enable = true;
        nameservers = [
            "1.1.1.1"
            "1.0.0.1"
        ];
    };

    users.defaultUserShell = pkgs.zsh;

    time.timeZone = "Europe/Paris";

    console.keyMap = "fr";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_FR.UTF-8";
        LC_IDENTIFICATION = "fr_FR.UTF-8";
        LC_MEASUREMENT = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
        LC_NAME = "fr_FR.UTF-8";
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_PAPER = "fr_FR.UTF-8";
        LC_TELEPHONE = "fr_FR.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
    };

    system = {
        stateVersion = "25.11";
        userActivationScripts.zshrc = "touch .zshrc";
        autoUpgrade.enable = true;
        autoUpgrade.dates = "daily";
    };

    programs.zsh.enable = true;

    environment = {
        shells = with pkgs; [ zsh ];
        variables = {
            LANG = "en_US.UTF-8";
            EDITOR = "nvim";
        };
        systemPackages = with pkgs; [
            neovim
            wakeonlan
        ];
    };

    nixpkgs.overlays = [ outputs.overlays.additions ];

    virtualisation.docker = {
        enable = true;
    };

    nix = {
        gc = {
            automatic = true;
            options = "--delete-older-than 10d";
            dates = "weekly";
        };
        settings = {
            auto-optimise-store = true;
            experimental-features = [
                "nix-command"
                "flakes"
            ];
            trusted-users = [
                "root"
                "@wheel"
            ];
        };
    };
}
