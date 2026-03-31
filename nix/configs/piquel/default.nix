{ outputs, inputs, pkgs, lib, ... }:
{
    imports = [ 
        outputs.nixosModules.tmux
        outputs.nixosModules.zsh
        outputs.nixosModules.nvim

        ./system.nix
        ./piquel-cli.nix
        inputs.piqueld.nixosModules.default
    ];

    users = {
        defaultUserShell = pkgs.zsh;
        users.piquel = {
            isNormalUser = true;
            extraGroups = [ "networkmanager" "wheel" "docker" "piqueld" ]; # "scanner" "lp" ];
            shell = pkgs.zsh;
            packages = with pkgs; [
                # Programmings languages
                rustup
                gcc go python3 deno
                nodejs jdk25 clang
                libcxx libgcc
                # Language servers
                nil nixfmt clang-tools
                marksman lombok gopls
                glsl_analyzer
                jdt-language-server
                dockerfile-language-server
                bash-language-server
                autotools-language-server
                lua-language-server
                tailwindcss-language-server
                svelte-language-server
                typescript-language-server
                vscode-langservers-extracted
                # Utils
                feh wl-clipboard stow tree yazi lazydocker
                ffmpeg fd ripgrep imagemagick poppler fzf air
                sqlc docker-buildx neofetch zoxide gnumake mpv
                p7zip postgresql cmake pkg-config tailwindcss_4
                grim swappy slurp file wayland-scanner btop gdb
                atlas
                # Apps
                blender kitty firefox hyprpaper prismlauncher
                discord heroic jetbrains-toolbox ladybird
                hyprlauncher hyprtoolkit hyprpolkitagent hyprpwcenter
                pwvucontrol spotify obsidian
                # Libs
                icu

                # Hazel
                premake5 gtk3 zlib elfutils libunwind tbb dotnetCorePackages.dotnet_9.sdk

                # UE5
                dotnetCorePackages.dotnet_9.sdk

                # DirkEngine
                wayland libxkbcommon
            ];
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHVqRluVYJXXoNYyFQzkZm2v2bRnAv/PNuoLRr2G2/Dv piquel@piquel.fr"
            ];
        };
    };

    nixpkgs = {
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "spotify"
            "jetbrains-toolbox"
            "discord"
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
            config = {
                init.defaultBranch = "main";
                core.editor = "vim";
                user = {
                    name = "piquel";
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
    };

    services = {
        tmux.enable = true;
        openssh = {
            enable = true;
            settings = {
                UsePAM = false;
                PasswordAuthentication = false;
                PermitRootLogin = "no";
            };
        };
        nvim = {
            enable = true;
            lsp = true;
        };
        flatpak.enable =true;
        hypridle.enable = true;
        locate = {
            enable = true;
            interval = "weekly";
        };
        zsh = {
            enable = true;
            enableVulkanConfig = true;
        };
        piqueld = {
            enable = true;
            enableDaemon = false;
            ctlSettings = {
                default_to_tcp = true;
                address = "192.168.1.44";
            };
        };
    };

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    };

    virtualisation.docker = {
        enable = true;
    };
}
