{ pkgs, lib, config, ... }:
let
    cfg = config.services.zsh;

    fzf-tab = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "master";
        hash = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
    };
in
{
    options.services.zsh = {
        enable = lib.mkEnableOption "Zsh Configuration";
        enableVulkanConfig = lib.mkEnableOption "Vulkan SDK environment setup";
    };

    config = lib.mkIf cfg.enable {
        programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableBashCompletion = true;
            autosuggestions.enable = true;
            syntaxHighlighting = {
                enable = true;
                highlighters = [ "main" "root"];
            };

            shellAliases = {
                l = "ls -alF";
                p = "piquel load $(piquel list | fzf)";
            };

            ohMyZsh = {
                enable = true;
                plugins = [ "git" ];
            };

            shellInit = ''
                fpath=(~/dotfiles/config/zsh-completions $fpath)

                export PATH="$HOME/go/bin:$HOME/.cargo/bin:$PATH"
                
                source ${fzf-tab}/fzf-tab.plugin.zsh
                ${lib.optionalString cfg.enableVulkanConfig ''
                source $HOME/VulkanSDK/setup-env.sh
                ''}
            '';
            promptInit = ''
                CASE_SENSITIVE="true"
                
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
        };
    };
}
