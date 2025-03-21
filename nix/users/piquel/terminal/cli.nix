{...}:
{
    programs = {
        git = {
            enable = true;
            lfs.enable = true;
            config = {
                init.defaultBranch = "main";
                core.editor = "nvim";
                user = {
                    name = "PiquelChips";
                    email = "63727792+PiquelChips@users.noreply.github.com";
                };
                url = {
                    "git@github.com:" = {
                        insteadOf = [ "https://github.com/" ];
                    };
                };
                filter."lfs" = {
                    clean = "git-lfs clean -- %f";
                    smudge = "git-lfs smudge -- %f";
                    process = "git-lfs filter-process";
                    required = true;
                };
            };
        };
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
