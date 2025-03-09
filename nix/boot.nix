{ lib, ... }:
let
    sources = import ./niv/sources.nix;
    lanzaboote = import sources.lanzaboote;
in
{
    imports =
      [
        lanzaboote.nixosModules.lanzaboote
      ];
    
    boot = {
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
            enable = true;
            pkiBundle = "/etc/secureboot";
        };
    };
}

