{ pkgs, ... }:
{
    users.users.piquel = {
        isNormalUser = true;
        description = "piquel";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        shell = pkgs.zsh;
        packages = with pkgs; [
          # Programming languages
          cargo gcc go
          deno nodejs python314
          # Language servers
          nil
          # Apps
          blender wofi kitty
          # Utilities
          feh zip unzip wl-clipboard stow
          ffmpeg fd ripgrep imagemagick poppler
          sqlc docker-buildx neofetch sesh zoxide
        ];
    };
    
    console.keyMap = "fr";
    
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
