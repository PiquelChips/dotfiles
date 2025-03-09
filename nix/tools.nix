{ ... }:
{
    programs = {
        fzf.fuzzyCompletion = true;
        neovim = {
                enable = true;
                defaultEditor = true;
                vimAlias = true;
        };
    };

    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };

    services.openssh.enable = true;
}
