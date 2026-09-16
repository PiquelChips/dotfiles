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

NixOS runs one `piqueld` service on localhost and Tailscale port 7846. The
upstream module owns socket permissions and runtime/state directories; the
`piquel` user receives API access through the `piqueld` group. Development uses
port 7845 and `/tmp/piqueld-dev-run/piqueld.sock` (`just dev` in
`~/Projects/piqueld`). The firewall exposes both TCP ports only on `tailscale0`.
macOS installs only the CLI and connects directly over the tailnet.

| Profile | NixOS socket | macOS URL |
| --- | --- | --- |
| `prod` | `/run/piqueld/piqueld.sock` | `http://nixosbtw.tailfcb6ab.ts.net:7846` |
| `dev` | `/tmp/piqueld-dev-run/piqueld.sock` | `http://nixosbtw.tailfcb6ab.ts.net:7845` |

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

### Validation

Evaluate and build the pinned integration:

```sh
# On NixOS:
nixos-rebuild build --flake .#piquel
# On macOS:
darwin-rebuild build --flake .#mac
```

After building and applying on each machine, verify the profile commands above
with both installed and development CLIs. Log out and back in on NixOS for the
new group membership. Confirm that only `piqueld.service` is needed, production
access works without sudo, and development and production use separate sockets
and HTTP ports.

macOS must be connected to the tailnet, and tailnet access rules should limit
these endpoints to the intended operators. Traffic is HTTP at the application
layer and encrypted by Tailscale; no `tailscale serve` configuration is needed.

## Left on Windows

- Microsoft 365
- Printing & Scanning

## Update

- Linux: `sudo nixos-rebuild switch --flake .#piquel --upgrade`
- macOS: `sudo darwin-rebuild switch --flake .#mac`
