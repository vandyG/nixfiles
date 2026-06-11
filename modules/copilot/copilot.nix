{ config, ... }:

{
  home.file.".copilot/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixfiles/modules/copilot/skills";

  programs.github-copilot-cli. = {
    enable = true;
    enableMcpIntegration = true;
  };
}
