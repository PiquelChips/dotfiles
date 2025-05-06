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
            extraGroups = [ "networkmanager" "wheel" "docker" ];
            shell = pkgs.zsh;
            packages = with pkgs; [
                # Programmings languages
                cargo gcc go python3
                deno nodejs jdk21
                # Language servers
                nil clang-tools libgcc marksman
                # Utils
                feh zip unzip wl-clipboard stow tree yazi lazydocker
                ffmpeg fd ripgrep imagemagick poppler fzf air
                sqlc docker-buildx neofetch zoxide gnumake mpv
                p7zip nix-index
                # Apps
                blender wofi kitty firefox hyprpaper gimp prismlauncher
                discord jetbrains.rider
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
        hyprland.enable = true;
        hyprlock.enable = true;
        steam = {
            enable = true;
            gamescopeSession.enable = true;
            extest.enable = true;
            localNetworkGameTransfers.openFirewall = true;
            #dedicatedServer.openFirewall = true; # Dedicated servers
            #remotePlay.openFirewall = true; # Remote play
        };
    };
    services.hypridle.enable = true;

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [ nerdfonts ];
    };

    environment = {
        shells = with pkgs; [ zsh ];
        variables = {
            LANG="en_US.UTF-8";
            EDITOR="nvim";

            VULKAN_SDK = "${pkgs.vulkan-headers}";
            VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
        };
    };
}
