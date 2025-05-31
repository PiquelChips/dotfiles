{...}:
{
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
    
    networking = {
        # firewall = {
        #     enable = false;
        #     allowedTCPPorts = [ 5432 ];
        #     allowedUDPPorts = [ 5432 ];
        # };
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
