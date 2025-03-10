{ pkgs, ... }:
{
    users.users.piquel = {
        isNormalUser = true;
        description = "piquel";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        shell = pkgs.zsh;
        packages = with pkgs; [
            # Programmings languages
            cargo gcc go
            deno nodejs
            # Language servers
            nil clang-tools libgcc
            # Utils
            feh zip unzip wl-clipboard stow tree yazi
            ffmpeg fd ripgrep imagemagick poppler fzf
            sqlc docker-buildx neofetch sesh zoxide
            # Apps
            blender wofi kitty firefox hyprpaper
        ];
    };

    console.keyMap = "fr";

    programs = {
        hyprland.enable = true;
        hyprlock.enable = true;
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
        };
    };
}
