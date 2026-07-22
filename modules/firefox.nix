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
