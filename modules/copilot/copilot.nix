{ copilotSources, ... }:

{
  programs.github-copilot-cli = {
    enable = true;
    enableMcpIntegration = true;
    skills = copilotSources.skills;
    agents = copilotSources.agents;
  };
}
