{ config, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "sidebar.verticalTabs" = true;
          "SanitizeOnShutdown" = {
            "Cache" = true;
            "Cookies" = true;
            "FormData" = true;
            "Sessions" = true;
            "SiteSettings" = true;
            "Locked" = true;
          };
        };
      };
    };
  };
}
