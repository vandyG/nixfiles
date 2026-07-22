{ copilotSources, ... }:

{
  programs.github-copilot-cli = {
    enable = true;
    enableMcpIntegration = true;
    skills = copilotSources.skills;
    agents = copilotSources.agents;

    # TODO: Add instructions support once the Home Manager module supports it. Currently, instructions are repository assets and not managed by the Home Manager module.
  };
  
}
