{ pkgs, ... }:
let
    fzf-tab = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "master";
        hash = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
    };
in
{
    programs.zsh = {
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
            plugins = [ "git" "sudo" "docker" ];
        };

        shellInit = "source ${fzf-tab}/fzf-tab.plugin.zsh";
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
}
