{ pkgs, inputs, outputs, lib, ... }:
{
    imports = [ 
        ../common.nix

        ./terminal
        ./system.nix
    ];

    users = {
        defaultUserShell = pkgs.zsh;
        users.piquel = {
            isNormalUser = true;
            extraGroups = [ "networkmanager" "wheel" "docker" ]; # "scanner" "lp" ];
            shell = pkgs.zsh;
            packages = with pkgs; [
                # Programmings languages
                cargo gcc go python3 deno
                nodejs jdk25 clang
                libcxx libgcc
                # Language servers
                nixd nixfmt clang-tools
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
                feh zip unzip wl-clipboard stow tree yazi lazydocker
                ffmpeg fd ripgrep imagemagick poppler fzf air
                sqlc docker-buildx neofetch zoxide gnumake mpv
                p7zip postgresql cmake pkg-config tailwindcss_4
                grim swappy slurp file wayland-scanner btop gdb
                # Apps
                blender kitty firefox hyprpaper gimp prismlauncher
                discord thunderbird heroic jetbrains-toolbox ladybird
                hyprlauncher hyprtoolkit hyprpolkitagent hyprpwcenter
                pwvucontrol spotify flatpak
                # Libs
                icu
                # Customs
                inputs.piquel-cli.packages.${pkgs.stdenv.hostPlatform.system}.default

                # Hazel
                premake5 gtk3 zlib elfutils libunwind tbb dotnetCorePackages.dotnet_9.sdk
            ];
        };
    };

    nixpkgs = {
        overlays = [ outputs.overlays.additions ];
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "spotify"
            "jetbrains-toolbox"
            "discord"
            "steam"
            "steam-original"
            "steam-unwrapped"
            "steam-run"
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
        neovim = {
            enable = true;
            defaultEditor = true;
            vimAlias = true;
        };
    };

    services = {
        hypridle.enable = true;
        locate = {
            enable = true;
            interval = "weekly";
        };
    };

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    };

    environment.variables.JDTLS_JVM_ARGS = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
}
