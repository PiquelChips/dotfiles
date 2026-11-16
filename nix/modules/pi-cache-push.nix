{ ... }:
{
  # This machine pushes every path it builds to piquel-pi's binary cache
  # (sourceorigin-dev/infra), which the binary-caches module substitutes from,
  # so a path built once isn't built again, here or on the other machines.
  flake.nixosModules.pi-cache-push =
    { config, pkgs, ... }:
    let
      # It resolves through the build-machine module's `/etc/hosts` entry.
      name = "piquel-pi.tailfcb6ab.ts.net";
      # The Pi's `nix-ssh` user may only speak the Nix daemon's protocol, and
      # lets this machine in by its host key.
      store = "ssh-ng://nix-ssh@${name}?ssh-key=/etc/ssh/ssh_host_ed25519_key";
    in
    {
      # Nix waits for this hook and stops building if it fails, so the copy
      # runs in a unit of its own and never holds a build up.
      # - One copy runs at a time: each sends what the Pi still lacks of a
      #   path's closure, so a large rebuild doesn't upload the same paths
      #   over dozens of SSH connections at once.
      # - The Pi checks signatures unless asked not to, and this machine's
      #   builds have none: harmonia signs them as it serves them.
      # - A path that misses the Pi, such as while it's off, only goes later
      #   with a build whose closure includes it.
      # - The unit's `PATH` is systemd's, without the `ssh` the copy runs.
      nix.settings.post-build-hook = pkgs.writeShellScript "push-to-pi" ''
        exec ${config.systemd.package}/bin/systemd-run --quiet --no-block --collect \
          --setenv=PATH=${config.programs.ssh.package}/bin \
          ${pkgs.util-linux}/bin/flock /run/push-to-pi.lock \
          ${config.nix.package}/bin/nix copy --no-check-sigs --to '${store}' $OUT_PATHS
      '';
      # What the copy checks the Pi's host key against.
      programs.ssh.knownHosts.${name}.publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtrAhMMQ4WDysvu1zbxrnARtl+B0TwR1ov5MC8Wut0F";
    };
}
