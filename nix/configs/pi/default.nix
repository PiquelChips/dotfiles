{ config, nixos-raspberrypi, pkgs, ... }:
{
    imports = with nixos-raspberrypi.nixosModules; [
        raspberry-pi-5.base
        raspberry-pi-5.page-size-16k
        raspberry-pi-5.bluetooth
        ./hardware-configuration.nix
    ];

    networking.hostName = "piquel";

    users.users.piquel = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
        ];
    };

    environment.systemPackages = with pkgs; [
        neovim
        wakeonlan
    ];

    boot.loader.raspberry-pi.bootloader = "kernel";
    services.openssh.enable = true;

    system.nixos.tags =
        let
            cfg = config.boot.loader.raspberry-pi;
        in
        [
            "raspberry-pi-${cfg.variant}"
            cfg.bootloader
            config.boot.kernelPackages.kernel.version
        ];

    system = {
        stateVersion = "25.11";
        userActivationScripts.zshrc = "touch .zshrc";
        autoUpgrade.enable = true;
        autoUpgrade.dates = "daily";
    };

    nix = {
        gc.automatic = true;
        gc.options = "--delete-older-than 10d";
        gc.dates = "weekly";
        settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
            trusted-users = [ "root" "@wheel" ];
        };
    };
}
