# piqueld runs on ovh-1 (sourceorigin-dev/infra). Here, only its CLI,
# pointed at that installation.
{ inputs, ... }:
let
  # Passkeys are bound to this origin: changing it invalidates every passkey.
  publicUrl = "https://dash.piqueld.dev";

  piquelctl = {
    enable = true;
    settings = {
      default = "prod";
      profiles.prod.url = publicUrl;
    };
  };
in
{
  flake.nixosModules.piqueld = {
    imports = [ inputs.piqueld.nixosModules.piquelctl ];
    programs.piquelctl = piquelctl;
  };

  flake.darwinModules.piqueld = {
    imports = [ inputs.piqueld.darwinModules.piquelctl ];
    programs.piquelctl = piquelctl;
  };
}
