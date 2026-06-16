{ config, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    # configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "sidebar.verticalTabs" = true;
        };
      };
    };
  };
}
