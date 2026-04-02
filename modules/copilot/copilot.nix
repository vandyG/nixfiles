{ config, ... }:

{
  home.file.".copilot/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixfiles/modules/copilot/skills";
}
