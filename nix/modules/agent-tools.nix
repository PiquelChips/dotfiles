{ ... }:
let
  agentsFile = ../../dotfiles/agents/AGENTS.md;
  skillsDirectory = ../../dotfiles/agents/skills;
  claudeSettings = ../../dotfiles/claude/settings.json;
  etcRoot = "/etc/dotfiles-agent-tools";

  etcFiles = {
    "dotfiles-agent-tools/AGENTS.md".source = agentsFile;
    "dotfiles-agent-tools/skills".source = skillsDirectory;
    "dotfiles-agent-tools/claude-settings.json".source = claudeSettings;
  };

  # Links the shared AGENTS.md, skills & Claude settings into a user's home.
  # Claude skills are linked one by one so ~/.claude/skills can still hold
  # skills synced by Claude itself.
  linkScript =
    {
      home,
      user,
      group,
    }:
    ''
      install -d -m 0700 -o ${user} -g ${group} ${home}/.codex ${home}/.agents ${home}/.claude ${home}/.claude/skills
      ln -sfn ${etcRoot}/AGENTS.md ${home}/.codex/AGENTS.md
      rm -rf ${home}/.agents/skills
      ln -s ${etcRoot}/skills ${home}/.agents/skills

      ln -sfn ${etcRoot}/AGENTS.md ${home}/.claude/CLAUDE.md
      ln -sfn ${etcRoot}/claude-settings.json ${home}/.claude/settings.json
      for skill in ${etcRoot}/skills/*; do
        ln -sfn "$skill" "${home}/.claude/skills/$(basename "$skill")"
      done
      # Drop links to skills that were removed from the dotfiles.
      find ${home}/.claude/skills -maxdepth 1 -type l ! -exec test -e {} \; -delete

      chown -h ${user}:${group} ${home}/.codex/AGENTS.md ${home}/.agents/skills \
        ${home}/.claude/CLAUDE.md ${home}/.claude/settings.json ${home}/.claude/skills/*
    '';
in
{
  flake.nixosModules.agent-tools =
    { pkgs, lib, ... }:
    {
      environment = {
        systemPackages = [ pkgs.codex ];
        etc = etcFiles;
      };

      system.activationScripts.agentTools =
        lib.stringAfter
          [
            "users"
            "etc"
          ]
          (linkScript {
            home = "/home/piquel";
            user = "piquel";
            group = "users";
          });
    };

  flake.darwinModules.agent-tools =
    { ... }:
    {
      environment.etc = etcFiles;

      system.activationScripts.postActivation.text = linkScript {
        home = "/Users/ronan";
        user = "ronan";
        group = "staff";
      };
    };
}
