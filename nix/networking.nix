{...}:
{
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
    
    networking = {
        hostName = "archbtw";
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
