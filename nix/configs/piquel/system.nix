{ pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    boot = {
        binfmt.emulatedSystems = [ "aarch64-linux" ];
        loader = {
            systemd-boot = {
                enable = true;
                configurationLimit = 20;
            };
            efi.canTouchEfiVariables = true;
        };
    };

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
            icu # localization lib

            # needs cleaning
            dbus
            pango
            cairo
            alsa-lib
            glib
            nss
            nspr
            at-spi2-core
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

            # For DirkEngine platform
            wayland
            libxkbcommon

            # Hazel
            gtk3 zlib elfutils libunwind tbb
        ];
    };

    networking = {
        hostName = "nixosbtw";
        networkmanager = {
            enable = true;
            wifi.backend = "iwd";
        };
        interfaces."enp39s0".wakeOnLan.enable = true;
        wireless.iwd = {
            enable = true;
            settings = {
                Settings = {
                    AutoConnect = true;
                };
            };
        };
    };
    
    environment.systemPackages = with pkgs; [
        xdg-user-dirs
        mesa
        alsa-utils
        alsa-scarlett-gui
    ];
}
