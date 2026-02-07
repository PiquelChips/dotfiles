{ pkgs, lib, ... }:
{
    imports = [ 
        ../common.nix

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
                # Apps
                blender kitty firefox hyprpaper gimp prismlauncher
                discord thunderbird heroic jetbrains-toolbox ladybird
                hyprlauncher hyprtoolkit hyprpolkitagent hyprpwcenter
                pwvucontrol spotify
                # Libs
                icu

                # Hazel
                premake5 gtk3 zlib elfutils libunwind tbb dotnetCorePackages.dotnet_9.sdk
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
        ];
    };

    programs = {
        nixvim.imports = [ ../../nvim/lsp.nix ];
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
    };

    services = {
        flatpak.enable =true;
        hypridle.enable = true;
        locate = {
            enable = true;
            interval = "weekly";
        };
        zsh = {
            enable = true;
            enableVulkanConfig = true;
            enableHomeConfig = true;
        };
    };

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    };

    environment.variables.JDTLS_JVM_ARGS = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
}
