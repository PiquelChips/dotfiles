{ ... }:
let
    port = 443;
in
{
    services = {
        tailscale.enable = true;
        headscale = {
            enable = true;
            address = "0.0.0.0";
            port = port;

            settings = {
                server_url = "https://headscale.piquel.fr:${builtins.toString port}";

                dns = {
                    magic_dns = true;
                    base_domain = "tailnet.piquel.fr";
                    override_local_dns = true;

                    nameservers = {
                        global = [ "1.1.1.1" ];
                    };
                };

                database = {
                    type = "sqlite";
                    sqlite = {
                        path = "/var/lib/headscale/db.sqlite"; # TODO: backup & save
                        write_ahead_log = true;
                    };
                };

                log = {
                    level = "debug";
                    format = "text";
                };
                
                tls_letsencrypt_hostname = "headscale.piquel.fr";
            };
        };
    };

    networking.firewall = {
        allowedTCPPorts = [ port ];
    };
}
