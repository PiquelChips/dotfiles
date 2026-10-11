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

NixOS runs one `piqueld` service. It joins the tailnet as its own node and
serves the dashboard and API over HTTPS at `https://piqueld.tailfcb6ab.ts.net`
(the passkey origin, `auth.public_url`). The upstream module owns socket
permissions and runtime/state directories; the `piquel` user can reach the
socket through the `piqueld` group. macOS installs only the CLI.

| Profile | NixOS socket | macOS URL |
| --- | --- | --- |
| `prod` | `/run/piqueld/piqueld.sock` | `https://piqueld.tailfcb6ab.ts.net` |

Upstream installs profiles in `/etc/piqueld/profiles.toml`. Both packaged and
development CLIs discover them natively, with user overrides in
`$XDG_CONFIG_HOME/piqueld/profiles.toml` (otherwise `~/.config/piqueld/profiles.toml`).
Every API call needs an account, including over the socket. Log in once per
machine:

```sh
piquelctl --profile prod login
piquelctl --profile prod status
```

Development instances (`just dev` in `~/Projects/piqueld`) serve on the shared
`piqueld-dev` tailnet node; use `just ctl` in the worktree to reach them.

Automation uses tokens from the dashboard's Accounts page via `PIQUELD_TOKEN`;
never put them in Nix. New tokens expire within 365 days.

### Ingress, DNS and notifications

Managed ingress runs without open ports:

- Public routes go through a locally managed Cloudflare Tunnel.
- Private routes go through a second tailnet node, `piqueld-apps`.
- A Cloudflare DNS provider issues private routes' certificates (DNS-01) and
  manages every route's records, including `hooks.piqueld.dev` for GitHub push
  webhooks.
- Notifications go to a Discord webhook.

The credentials are agenix secrets, read by systemd and handed to piqueld:

| Secret | Contents |
| --- | --- |
| `piqueld-cloudflared-tunnel.age` | The JSON from `cloudflared tunnel create piqueld` |
| `piqueld-cloudflare-dns-token.age` | Cloudflare API token, Zone:Read and DNS:Edit on the piqueld zones |
| `piqueld-discord-webhook.age` | Discord channel webhook URL |

Edit one with `agenix -e <name>` from `secrets/`. Restart piqueld after
changing a secret.

### First deployment

Upgrading an existing daemon migrates its database irreversibly. Back up
`/var/lib/piqueld` first (`sudo systemctl stop piqueld`, then copy the whole
directory). After switching, open the link in `/var/lib/piqueld/setup-link`
(root-readable) and register the first account's passkey. Log out and back in on
NixOS to pick up the group membership.

On the first start with private ingress, approve the `piqueld-apps` node with
the login URL from `journalctl -u piqueld`.

Back up `/var/lib/piqueld` as a unit: it holds `piqueld.db`, `secrets.key`
(the master key for application secrets, which cannot be recovered without
it), both tailnet nodes' identities and the ingress certificates.

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
