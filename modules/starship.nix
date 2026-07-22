{ lib, ... }:

let
  catppuccinFlavour = "latte"; # one of: mocha | frappe | macchiato | latte
  themes = {
    catppuccin = import ./starship-themes/catppuccin.nix catppuccinFlavour;
    gruvbox_dark = import ./starship-themes/gruvbox_dark.nix;
  };
  theme = themes.catppuccin;
  commonSettings = {
    os = {
      disabled = false;
      symbols = {
        Windows = "";
        Ubuntu = "󰕈";
        SUSE = "";
        Raspbian = "󰐿";
        Mint = "󰣭";
        Macos = "󰀵";
        Manjaro = "";
        Linux = "󰌽";
        Gentoo = "󰣨";
        Fedora = "󰣛";
        Alpine = "";
        Amazon = "";
        Android = "";
        AOSC = "";
        Arch = "󰣇";
        Artix = "󰣇";
        EndeavourOS = "";
        CentOS = "";
        Debian = "󰣚";
        Redhat = "󱄛";
        RedHatEnterprise = "󱄛";
        Pop = "";
      };
    };

    username.show_always = true;

    directory = {
      truncation_length = 3;
      truncation_symbol = "…/";
      substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = "󰝚 ";
        "Pictures" = " ";
        "Developer" = "󰲋 ";
      };
    };

    time = {
      disabled = false;
      time_format = "%R";
    };
  };
in
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;

    settings = lib.recursiveUpdate commonSettings theme.settings;
  };
}
