{ pkgs, inputs, lib, ... }:
{
    imports = [ 
        ./terminal/default.nix
    ];

    users = {
        defaultUserShell = pkgs.zsh;
        users.piquel = {
            isNormalUser = true;
            description = "piquel";
            extraGroups = [ "networkmanager" "wheel" "docker" ]; # "scanner" "lp" ];
            shell = pkgs.zsh;
            packages = with pkgs; [
                # Programmings languages
                cargo gcc go python3 deno
                nodejs jdk21 clang
                libcxx libgcc
                # Language servers
                nil clang-tools
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
                hyprshutdown
                pwvucontrol spotify
                # Libs
                icu
                # Customs
                inputs.piquel-cli.packages.${pkgs.stdenv.hostPlatform.system}.default

                # Hazel
                premake5 gtk3 zlib elfutils libunwind tbb dotnetCorePackages.dotnet_9.sdk
            ];
        };
    };

    console.keyMap = "fr";

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "spotify"
        "jetbrains-toolbox"
        "discord"
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
    ];

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
            enableZshIntegration = false;
            enableBashIntegration = false;
            enableFishIntegration = false;
        };
    };
    services.hypridle.enable = true;

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    };

    environment = {
        shells = with pkgs; [ zsh ];
        variables = {
            LANG="en_US.UTF-8";
            EDITOR="nvim";

            JDTLS_JVM_ARGS = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
        };
    };
}
