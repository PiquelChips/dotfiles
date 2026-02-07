{ outputs, inputs, pkgs, ... }:
{
    imports = [
        outputs.nixosModules.piquel-cli
        outputs.nixosModules.tmux
        outputs.nixosModules.zsh
        inputs.nixvim.nixosModules.nixvim
    ];

    nixpkgs.overlays = [ outputs.overlays.additions ];

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

    programs = {
        git = {
            enable = true;
            lfs.enable = true;
            config = {
                init.defaultBranch = "main";
                core.editor = "nvim";
                user = {
                    name = "PiquelChips";
                    email = "piquel@piquel.fr";
                };
                url = {
                    "git@github.com:" = {
                        insteadOf = [ "https://github.com/" ];
                    };
                };
                filter."lfs" = {
                    clean = "git-lfs clean -- %f";
                    smudge = "git-lfs smudge -- %f";
                    process = "git-lfs filter-process";
                    required = true;
                };
            };
        };
        nixvim = {
            enable = true;
            defaultEditor = true;
            imports = [ ../nvim ];
        };
    };

    services = {
        zsh.enable = true;
        tmux.enable = true;
        piquel-cli.enable = true;
        openssh = {
            enable = true;
            settings = {
                UsePAM = false;
                PasswordAuthentication = false;
                PermitRootLogin = "no";
            };
        };
    };

    environment = {
        shells = with pkgs; [ zsh ];
        variables = {
            LANG = "en_US.UTF-8";
            EDITOR = "nvim";
        };
        systemPackages = with pkgs; [
            zsh neovim zip unzip tree fd fzf file
        ];
    };

    virtualisation.docker = {
        enable = true;
    };
}
