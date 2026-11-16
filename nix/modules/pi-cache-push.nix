{ ... }:
{
  # This machine pushes every path it builds to piquel-pi's binary cache
  # (sourceorigin-dev/infra), which the binary-caches module substitutes from,
  # so a path built once isn't built again, here or on the other machines.
  flake.nixosModules.pi-cache-push =
    { config, pkgs, ... }:
    let
      name = "piquel-pi.tailfcb6ab.ts.net";
      # The Pi's `nix-ssh` user may only speak the Nix daemon's protocol, and
      # lets this machine in by its host key.
      store = "ssh-ng://nix-ssh@${name}?ssh-key=/etc/ssh/ssh_host_ed25519_key";
    in
    {
      # Nix waits for this hook and stops building if it fails, so the copy
      # runs in a unit of its own and never holds a build up. A path that
      # misses the Pi, such as while it's off, goes with the next build that
      # depends on it: the copy sends a path's whole closure. Its unit's
      # `PATH` is systemd's, without the `ssh` the copy runs.
      nix.settings.post-build-hook = pkgs.writeShellScript "push-to-pi" ''
        exec ${config.systemd.package}/bin/systemd-run --quiet --no-block --collect \
          --setenv=PATH=${config.programs.ssh.package}/bin \
          ${config.nix.package}/bin/nix copy --to '${store}' $OUT_PATHS
      '';
      # What the copy checks the Pi's host key against.
      programs.ssh.knownHosts.${name}.publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtrAhMMQ4WDysvu1zbxrnARtl+B0TwR1ov5MC8Wut0F";
    };
}
