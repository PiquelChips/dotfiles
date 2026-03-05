{ inputs, ... }:
{
    imports = [
        inputs.piquel-cli.nixosModule
    ];

    programs.piquelcli = {

    };
}
