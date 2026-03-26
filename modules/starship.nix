{ lib, ... }:

let
  themeName = "catppuccin_mocha";
  themes = {
    catppuccin_mocha = import ./starship-themes/catppuccin_mocha.nix;
    gruvbox_dark = import ./starship-themes/gruvbox_dark.nix;
  };
  theme = themes.${themeName};
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
