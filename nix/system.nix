{ pkgs, ... }:
{
    imports = [
        ./networking.nix
        ./hardware-configuration.nix
    ];

    boot.loader = {
        systemd-boot = {
            enable = true;
            configurationLimit = 20;
        };
        efi.canTouchEfiVariables = true;
    };

    time.timeZone = "Europe/Paris";
    
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_FR.UTF-8";
        LC_IDENTIFICATION = "fr_FR.UTF-8";
        LC_MEASUREMENT = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
        LC_NAME = "fr_FR.UTF-8";
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_PAPER = "fr_FR.UTF-8";
        LC_TELEPHONE = "fr_FR.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
    };

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
            icu

            # needs cleaning
            dbus
            pango
            cairo
            alsa-lib
            glib
            nss
            nspr
            at-spi2-core
            libxkbcommon
            libgbm
            libdrm
            expat

            # this too
            xorg.libxcb
            xorg.libX11 
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXext
            xorg.libXfixes
            xorg.libXrandr
        ];
    };
    
    system = {
        stateVersion = "25.05";
        userActivationScripts.zshrc = "touch .zshrc";
        autoUpgrade.enable = true;
        autoUpgrade.dates = "daily";
    };

    environment.systemPackages = with pkgs; [
        xdg-user-dirs
        mesa
    ];

    nix = {
        gc.automatic = true;
        gc.options = "--delete-older-than 10d";
        gc.dates = "weekly";
        settings.auto-optimise-store = true;
        settings.experimental-features = [ "nix-command" "flakes" ];
    };
}
