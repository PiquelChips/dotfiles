{ pkgs, ...}:
{
    programs = {
        zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            shellAliases = {
                l = "ls -alF";
                s = "sesh connect $(sesh list -c -t | fzf)";
            };
            ohMyZsh = {
                enable = true;
                plugins = [ "git" "sudo" "docker" ]; #"fzf-tab" ];
            };
            promptInit = ''
                CASE_SENSITIVE="true"
        
                PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%~%{$reset_color%}"
                PROMPT+=' $(git_prompt_info)'
                
                ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
                ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
                ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
                ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
            '';
        };
        git = {
            enable = true;
            lfs.enable = true;
            config = {
                init.defaultBranch = "main";
                core.editor = "nvim";
                user = {
                    name = "PiquelChips";
                    email = "63727792+PiquelChips@users.noreply.github.com";
                };
                #url."git@github.com:".insteadOf = [ "https://github.com/" ];
                filter."lfs" = {
                    clean = "git-lfs clean -- %f";
                    smudge = "git-lfs smudge -- %f";
                    process = "git-lfs filter-process";
                    required = true;
                };
            };
        };
        tmux = {
            enable = true;
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
            '';
            plugins = with pkgs.tmuxPlugins; [
                sensible vim-tmux-navigator
                #tokyo-night-tmux
            ];
            extraConfig = ''
                bind '"' split-window -v -c "#{pane_current_path}"
                bind % split-window -h -c "#{pane_current_path}"
            '';
        };
    };
}
