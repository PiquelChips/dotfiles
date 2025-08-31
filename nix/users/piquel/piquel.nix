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
                cargo gcc go python3
                deno nodejs jdk21 clang
                # Language servers
                nil clang-tools libgcc marksman lombok gopls
                glsl_analyzer
                jdt-language-server
                dockerfile-language-server-nodejs
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
                grim swappy slurp premake5
                # Apps
                blender wofi kitty firefox hyprpaper gimp prismlauncher
                discord jetbrains.rider thunderbird heroic
                # Customs
                inputs.piquel-cli.packages.${pkgs.system}.default

            ];
        };
    };

    console.keyMap = "fr";

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "rider"
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
