# dotfiles
My dotfiles

## Setup machine

- ```nix-shell -p git --run "git clone https://github.com/PiquelChips/dotfiles ~"```
- ```sh dotfiles/setup.sh```

## Setup macOS

- Install Nix or Lix.
- Install Homebrew if you want nix-darwin to manage GUI casks.
- Clone this repo.
- Apply the Darwin configuration:

  ```sh
  sudo nix --extra-experimental-features "nix-command flakes" run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake .#mac
  ```

After the first switch, update with:

```sh
sudo darwin-rebuild switch --flake .#mac
```

## piqueld

NixOS runs one `piqueld` service on localhost port 7846. Tailscale Serve
terminates HTTPS at `https://nixosbtw.tailfcb6ab.ts.net` (the passkey origin,
`auth.public_url`) and proxies to it, so the dashboard and CLI work from any
tailnet device. The upstream module owns socket permissions and runtime/state
directories; the `piquel` user can reach the socket through the `piqueld` group.
Development uses port 7845 and `/tmp/piqueld-dev-run/piqueld.sock` (`just dev`
in `~/Projects/piqueld`); the firewall exposes 7845 only on `tailscale0`.
macOS installs only the CLI.

| Profile | NixOS socket | macOS URL |
| --- | --- | --- |
| `prod` | `/run/piqueld/piqueld.sock` | `https://nixosbtw.tailfcb6ab.ts.net` |
| `dev` | `/tmp/piqueld-dev-run/piqueld.sock` | `http://nixosbtw.tailfcb6ab.ts.net:7845` |

Upstream installs profiles in `/etc/piqueld/profiles.toml`. Both packaged and
development CLIs discover them natively, with user overrides in
`$XDG_CONFIG_HOME/piqueld/profiles.toml` (otherwise `~/.config/piqueld/profiles.toml`).
Every API call needs an account, including over the socket. Log in once per
profile and machine (select a profile explicitly or set `PIQUELD_PROFILE`):

```sh
piquelctl --profile prod login
piquelctl --profile prod status
piquelctl --profile dev login
# From the piqueld checkout:
cargo run -p piquelctl -- --profile dev status
```

The dev daemon's passkey origin is `http://localhost:7845`, so approve its
logins in a browser on NixOS. From macOS, the dev profile is plain HTTP and
needs `--allow-insecure-http` on every command.

Automation uses tokens from the dashboard's Accounts page via `PIQUELD_TOKEN`;
never put them in Nix. Managed ingress stays disabled: it needs public ports
80/443, which this machine does not have.

### First deployment

Tailscale Serve config persists in tailscaled state. Set it up once on
`nixosbtw` (this replaces the old mapping to the dev port):

```sh
sudo tailscale serve --bg --https=443 http://127.0.0.1:7846
tailscale serve status
```

Upgrading an existing daemon migrates its database irreversibly. Back up
`/var/lib/piqueld` first (`sudo systemctl stop piqueld`, then copy the whole
directory). After switching, open the link in `/var/lib/piqueld/setup-link`
(root-readable) and register the first account's passkey. Log out and back in on
NixOS to pick up the group membership.

Back up `/var/lib/piqueld` as a unit: it holds `piqueld.db` and `secrets.key`,
the master key for application secrets. Without the key, secret values cannot
be recovered.

### Validation

Evaluate and build the pinned integration:

```sh
# On NixOS:
nixos-rebuild build --flake .#piquel
# On macOS:
darwin-rebuild build --flake .#mac
```

After applying on each machine, run the profile commands above. Confirm that
production login works without sudo and that the dashboard loads over HTTPS from
macOS. Tailnet access rules should limit these endpoints to the intended
operators.

## Left on Windows

- Microsoft 365
- Printing & Scanning

## Update

- Linux: `sudo nixos-rebuild switch --flake .#piquel --upgrade`
- macOS: `sudo darwin-rebuild switch --flake .#mac`
