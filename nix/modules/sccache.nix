{ ... }:
let
  # Wraps every rustc call in sccache, so worktrees of the same project share
  # compiled dependencies instead of each building them from scratch.
  # Workspace crates are compiled incrementally, which sccache skips.
  sccacheModule =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = [ pkgs.sccache ];
        variables = {
          RUSTC_WRAPPER = "sccache";
          SCCACHE_CACHE_SIZE = "200G";
        };
      };
    };
in
{
  flake.nixosModules.sccache = sccacheModule;
  flake.darwinModules.sccache = sccacheModule;
}
