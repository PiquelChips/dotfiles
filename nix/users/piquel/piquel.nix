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
                deno nodejs jdk21
                # Language servers
                nil clang-tools libgcc marksman jdt-language-server
                lombok gopls dockerfile-language-server-nodejs
                bash-language-server autotools-language-server
                lua-language-server
                # Utils
                feh zip unzip wl-clipboard stow tree yazi lazydocker
                ffmpeg fd ripgrep imagemagick poppler fzf air
                sqlc docker-buildx neofetch zoxide gnumake mpv
                p7zip nix-index postgresql cmake
                # Apps
                blender wofi kitty firefox hyprpaper gimp prismlauncher
                discord jetbrains.rider
                # Customs
                inputs.piquel-cli.packages.${pkgs.system}.default

                # Vulkan dev
                vulkan-headers
                vulkan-loader
                vulkan-validation-layers
                vulkan-tools
                spirv-tools
                glfw glm shaderc
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

    # hardware.sane = {
    #     enable = true;
    #     extraBackends = [
    #         pkgs.sane-airscan
    #         #pkgs.hplipWithPlugin
    #     ];
    # };

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
    services = {
        hypridle.enable = true;
        # printing.enable = true;
        # avahi = {
        #     enable = true;
        #     nssmdns4 = true;
        #     openFirewall = true;
        # };
        # udev.packages = [ pkgs.sane-airscan ];
    };

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    };

    environment = {
        shells = with pkgs; [ zsh ];
        variables = {
            LANG="en_US.UTF-8";
            EDITOR="nvim";

            LIBRARY_PATH = "${pkgs.spirv-tools}/lib:${pkgs.glm}/lib:${pkgs.glfw}/lib:${pkgs.vulkan-loader}/lib:${pkgs.vulkan-validation-layers}/lib";
            VULKAN_SDK = "${pkgs.vulkan-headers}";
            VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            JDTLS_JVM_ARGS = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
        };
    };
}
