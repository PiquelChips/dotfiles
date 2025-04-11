{ ... }:
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
    
    system = {
        stateVersion = "24.11";
        userActivationScripts.zshrc = "touch .zshrc";
        autoUpgrade.enable = true;
        autoUpgrade.dates = "daily";
    };
  
    nix = {
        gc.automatic = true;
        gc.options = "--delete-older-than 10d";
        gc.dates = "weekly";
        settings.auto-optimise-store = true;
        settings.experimental-features = [ "nix-command" "flakes" ];
    };
}
