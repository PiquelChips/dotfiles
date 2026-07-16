{ ... }:
let
  shellInit =
    {
      pkgs,
      lib,
      completionPaths,
      ...
    }:
    ''
      export TMUX_TMPDIR="${XDG_RUNTIME_DIR: -/tmp}"
      fpath=(${completionPaths} $fpath)

      ${lib.optionalString pkgs.stdenv.isLinux ''
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH"
      ''}
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        path=(/run/current-system/sw/bin /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/local/sbin $path)
      ''}
      path=("$HOME/.cargo/bin" "$HOME/.local/share/pnpm/bin" $path)
      typeset -U path

      source ${
        pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "master";
          hash = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
        }
      }/fzf-tab.plugin.zsh
    '';

  promptInit = ''
    CASE_SENSITIVE="true"
    setopt prompt_subst

    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "''${terminfo[kcuu1]}" up-line-or-beginning-search
    bindkey "''${terminfo[kcud1]}" down-line-or-beginning-search
    bindkey "^[[A" up-line-or-beginning-search
    bindkey "^[[B" down-line-or-beginning-search

    PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} )%{$fg[cyan]%}"

    if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        PROMPT+="%n@%m:"
    fi

    PROMPT+="%~%{$reset_color%}"
    PROMPT+=' $(git_prompt_info)'

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
  '';
in
{
  flake.nixosModules.zsh =
    { pkgs, lib, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting = {
          enable = true;
          highlighters = [
            "main"
            "root"
          ];
        };

        shellAliases = {
          l = "ls -alF";
          p = "piquel pick";
        };

        ohMyZsh = {
          enable = true;
          plugins = [ "git" ];
        };

        shellInit = shellInit {
          inherit pkgs lib;
          completionPaths = "~/dotfiles/config/zsh-completions";
        };
        inherit promptInit;
      };
    };

  flake.darwinModules.zsh =
    { pkgs, lib, ... }:
    {
      environment.shellAliases = {
        l = "ls -alF";
        p = "piquel pick";
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        shellInit = shellInit {
          inherit pkgs lib;
          completionPaths = "~/Projects/dotfiles/config/zsh-completions ~/dotfiles/config/zsh-completions";
        };
        promptInit = ''
          autoload -U colors && colors

          git_prompt_info() {
            local branch dirty
            branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)" || return
            git diff --quiet --ignore-submodules HEAD 2>/dev/null || dirty=" %{$fg[yellow]%}%1{✗%}"
            print -r -- "%{$fg_bold[blue]%}git:(%{$fg[red]%}''${branch}%{$fg[blue]%})''${dirty}%{$reset_color%} "
          }

          ${promptInit}
        '';
      };
    };
}
