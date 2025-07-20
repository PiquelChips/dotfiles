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
                grim swappy slurp
                # Apps
                blender wofi kitty firefox hyprpaper gimp prismlauncher
                discord jetbrains.rider thunderbird heroic
                # Customs
                inputs.piquel-cli.packages.${pkgs.system}.default

                # pkg-config
                wayland.dev
                libxkbcommon.dev
                libffi.dev
                wayland-scanner
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
        variables = 
        let 
            vulkan_sdk = "/home/piquel/Vulkan-SDK/x86_64";
        in
        {
            LANG="en_US.UTF-8";
            EDITOR="nvim";

            # needed to build glfw
            PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig:${pkgs.wayland.dev}/lib/pkgconfig:${pkgs.libxkbcommon.dev}/lib/pkgconfig:${pkgs.libffi.dev}/lib/pkgconfig";
            DIRK_ENGINE_CMAKE_ARGS = "-DGLFW_BUILD_X11=OFF";

            # the Vulkan SDK
            LD_LIBRARY_PATH = "${pkgs.wayland}/lib:${pkgs.libxkbcommon}/lib:${vulkan_sdk}/lib";
            VK_LAYER_PATH = "${vulkan_sdk}/share/vulkan/explicit_layer.d";
            VULKAN_SDK = vulkan_sdk;

            JDTLS_JVM_ARGS = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
        };
    };
}
