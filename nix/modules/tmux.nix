{ ... }:
let
  tmuxConfigBeforePlugins = ''
    # Set prefix
    unbind C-b
    set -g prefix C-s
    bind C-s send-prefix

    # Window switching
    bind h previous-window
    bind l next-window
    bind H previous-window
    bind L next-window
    bind Tab next-window
    bind BTab previous-window
    bind -n M-h previous-window
    bind -n M-l next-window
    bind -n M-H previous-window
    bind -n M-L next-window
    bind -n M-Left previous-window
    bind -n M-Right next-window

    # Copy mode prefix
    bind 'v' copy-mode

    # 1 based indexing for windows
    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-window-option -g mode-keys vi
    set-option -g renumber-windows on

    set -g detach-on-destroy off
    # Send clipboard over SSH
    set -s set-clipboard on
  '';

  tmuxExtraConfig = ''
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
  '';

  tmuxConfig = ''
    ${tmuxConfigBeforePlugins}
    ${tmuxExtraConfig}
  '';
in
{
  flake.nixosModules.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        extraConfigBeforePlugins = tmuxConfigBeforePlugins;
        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          #tokyo-night-tmux
        ];
        extraConfig = tmuxExtraConfig;
      };
    };

  flake.darwinModules.tmux =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = [ pkgs.tmux ];
        etc."tmux.conf".text = tmuxConfig;
      };
    };
}
