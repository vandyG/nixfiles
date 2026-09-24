{ config, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    # configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      "SearchEngines" = {
        "Add" = [
          {
            "Name" = "Nix Packages";
            "URLTemplate" = "https://search.nixos.org/packages?channel=unstable&q={searchTerms}";
            "Method" = "GET";
            "Alias" = "@nix";
            "Description" = "Search Nix Packages on the unstable channel";
          }
        ];
      };

      "SanitizeOnShutdown" = {
        "Cache" = true;
        "Cookies" = true;
        "Sessions" = true;
        "Exceptions" = [
          "https://www.google.com"
          "https://www.youtube.com"
          "https://www.reddit.com"
          "https://www.github.com"
          "https://mail.google.com"
          "https://music.youtube.com"
        ];
      };
    };
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
