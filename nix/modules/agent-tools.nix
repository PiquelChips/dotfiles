{ ... }:
let
  agentsFile = ../../dotfiles/agents/AGENTS.md;
  skillsDirectory = ../../dotfiles/agents/skills;
  etcRoot = "/etc/dotfiles-agent-tools";
in
{
  flake.nixosModules.agent-tools =
    { pkgs, lib, ... }:
    {
      environment = {
        systemPackages = [ pkgs.codex ];
        etc = {
          "dotfiles-agent-tools/AGENTS.md".source = agentsFile;
          "dotfiles-agent-tools/skills".source = skillsDirectory;
        };
      };

      system.activationScripts.agentTools = lib.stringAfter [ "users" ] ''
        install -d -m 0700 -o piquel -g users /home/piquel/.codex /home/piquel/.agents
        ln -sfn ${etcRoot}/AGENTS.md /home/piquel/.codex/AGENTS.md
        rm -rf /home/piquel/.agents/skills
        ln -s ${etcRoot}/skills /home/piquel/.agents/skills
        chown -h piquel:users /home/piquel/.codex/AGENTS.md /home/piquel/.agents/skills
      '';
    };

  flake.darwinModules.agent-tools =
    { ... }:
    {
      environment.etc = {
        "dotfiles-agent-tools/AGENTS.md".source = agentsFile;
        "dotfiles-agent-tools/skills".source = skillsDirectory;
      };

      system.activationScripts.postActivation.text = ''
        install -d -m 0700 -o ronan -g staff /Users/ronan/.codex /Users/ronan/.agents
        ln -sfn ${etcRoot}/AGENTS.md /Users/ronan/.codex/AGENTS.md
        rm -rf /Users/ronan/.agents/skills
        ln -s ${etcRoot}/skills /Users/ronan/.agents/skills
        chown -h ronan:staff /Users/ronan/.codex/AGENTS.md /Users/ronan/.agents/skills
      '';
    };
}
