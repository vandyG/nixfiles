{
  config,
  copilotSources,
  lib,
  ...
}:

let
  copilotConfigDir = config.programs.github-copilot-cli.configDir;
  homePrefix = "${config.home.homeDirectory}/";
  copilotConfigDirRel = lib.removePrefix homePrefix copilotConfigDir;
  copilotInstructionsDirRel = "${copilotConfigDirRel}/instructions";
in

{
  programs.github-copilot-cli = {
    enable = true;
    enableMcpIntegration = true;
    skills = copilotSources.skills;
    agents = copilotSources.agents;
  };

  assertions = [
    {
      assertion = lib.hasPrefix homePrefix copilotConfigDir;
      message = ''
        modules/copilot/copilot.nix: programs.github-copilot-cli.configDir must be inside $HOME
        so instructions can be linked with home.file. Current value: ${copilotConfigDir}
      '';
    }
  ];

  home.file = lib.mapAttrs' (
    name: source: {
      name = "${copilotInstructionsDirRel}/${name}.instructions.md";
      value = { inherit source; };
    }
  ) copilotSources.instructions;
}
