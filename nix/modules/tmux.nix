{ pkgs, config, lib, ... }:
let
    cfg = config.services.tmux;
in
{
    options.services.tmux = {
        enable = lib.mkEnableOption "Tmux Configuration";

        package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.tmux;
            defaultText = lib.literalExpression "pkgs.tmux";
            example = lib.literalExpression "pkgs.tmux";
        };
    };

    config = lib.mkIf cfg.enable {
        programs.tmux = {
            enable = true;
            package = cfg.package;
            baseIndex = 1;
            extraConfigBeforePlugins = ''
                # Set prefix
                unbind C-b
                set -g prefix C-s
                bind C-s send-prefix

                # Shift Alt vim keys to switch windows
                bind -n M-H previous-window
                bind -n M-L next-window

                # Copy mode prefix
                bind 'v' copy-mode

                # 1 based indexing for windows
                set -g base-index 1
                set -g pane-base-index 1
                set-window-option -g pane-base-index 1
                set-window-option -g mode-keys vi
                set-option -g renumber-windows on

                set -g detach-on-destroy off
            '';
            plugins = with pkgs.tmuxPlugins; [
                sensible
                vim-tmux-navigator
                #tokyo-night-tmux
            ];
            extraConfig = ''
                bind '"' split-window -v -c "#{pane_current_path}"
                bind % split-window -h -c "#{pane_current_path}"
            '';
        };
    };
}
