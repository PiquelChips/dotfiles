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

This integration targets the upstream changes in
[piqueld#86](https://github.com/piquel-fr/piqueld/issues/86),
[#87](https://github.com/piquel-fr/piqueld/issues/87), and
[#88](https://github.com/piquel-fr/piqueld/issues/88). The current pin does not
implement that interface: Darwin evaluation requires the new CLI module export,
and Linux needs the group-accessible runtime socket and native profile discovery.
Update the piqueld input after those changes land before deploying this configuration.

### Intended configuration

NixOS runs one `piqueld` service with upstream defaults and HTTP on
`127.0.0.1:7846`. The upstream module owns socket permissions and runtime/state
directories; the `piquel` user receives API access through the `piqueld` group.
Development keeps `127.0.0.1:7845` and `/tmp/piqueld-dev/piqueld.sock`
(`just dev` in `~/Projects/piqueld`). macOS installs only the CLI.

| Profile | NixOS socket | macOS URL |
| --- | --- | --- |
| `prod` | `/run/piqueld/piqueld.sock` | `https://nixosbtw.tailfcb6ab.ts.net:8443` |
| `dev` | `/tmp/piqueld-dev/piqueld.sock` | `https://nixosbtw.tailfcb6ab.ts.net` |

Upstream installs profiles in `/etc/piqueld/profiles.toml`. Both packaged and
development CLIs discover them natively, with user overrides in
`$XDG_CONFIG_HOME/piqueld/profiles.toml` (otherwise `~/.config/piqueld/profiles.toml`).
Select a profile explicitly or set `PIQUELD_PROFILE`:

```sh
piquelctl --profile prod status
piquelctl --profile dev status
# From the piqueld checkout:
cargo run -p piquelctl -- --profile dev status
```

### Validation with an upstream checkout

Evaluate and build against your implementation without changing the lock file:

```sh
# On NixOS:
nixos-rebuild build --flake .#piquel --override-input piqueld path:/home/piquel/Projects/piqueld
# On macOS (adjust the checkout path if needed):
darwin-rebuild build --flake .#mac --override-input piqueld path:/Users/ronan/Projects/piqueld
```

After building and applying on each machine, verify the profile commands above
with both installed and development CLIs. Log out and back in on NixOS for the
new group membership. Confirm that only `piqueld.service` is needed, production
access works without sudo, and development and production use separate sockets
and HTTP ports. Remove any old `PIQUELD_PROFILES_FILE` override when validating
native profile discovery.

### Manual Tailscale setup

On `nixosbtw`, configure the persistent mappings yourself:

```sh
sudo tailscale serve --bg --https=8443 http://127.0.0.1:7846
sudo tailscale serve --bg --https=443 http://127.0.0.1:7845
tailscale serve status
```

macOS must be connected to the tailnet, and tailnet access rules should limit
these endpoints to the intended operators. Tailscale Serve handles HTTPS;
piqueld retains its loopback HTTP listener. No additional systemd service or
project-session command manages Serve.

## Left on Windows

- Microsoft 365
- Printing & Scanning

## Update

- Linux: `sudo nixos-rebuild switch --flake .#piquel --upgrade`
- macOS: `sudo darwin-rebuild switch --flake .#mac`
