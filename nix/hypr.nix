{ pkgs, ... }:
{
    services = {
        hypridle = {
            enable = true;
        };
    };
    programs = {
        hyprlock = {
            enable = true;
        };
        hyprland = {
            enable = true;
        };
    };
    environment.systemPackages = with pkgs; [ hyprpaper ];
}
