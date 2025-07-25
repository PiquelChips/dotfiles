{...}:
{
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
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
}
