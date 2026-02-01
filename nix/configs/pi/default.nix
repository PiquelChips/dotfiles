{ config, nixos-raspberrypi, pkgs, ... }:
{
    imports = with nixos-raspberrypi.nixosModules; [
        ../common.nix

        raspberry-pi-5.base
        raspberry-pi-5.page-size-16k
        raspberry-pi-5.bluetooth
        ./hardware-configuration.nix
    ];

    networking.hostName = "piquel";
    boot.loader.raspberry-pi.bootloader = "kernel";

    users.users.piquel = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        shell = pkgs.zsh;
    };

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
}
