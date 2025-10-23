{ config, pkgs, lib, ... }:
let cfg = config.gnome;
in {
  imports = [
    (lib.mkAliasOptionModule [ "gnome" "gtkAppTheme" ] [ "gtk" "theme" ])
    (lib.mkAliasOptionModule [ "gnome" "gtkIconTheme" ] [ "gtk" "iconTheme" ])
  ];
  options.gnome.shellTheme = lib.mkOption {
    description = ''
      The custom shell theme to use.
    '';
    type = with lib.types;
      nullOr (submoduleWith {
        modules = [{
          options = {
            package = mkOption {
              type = with types; nullOr package;
              default = pkgs.gruvbox-gtk-theme;
              defaultText = literalExpression "pkgs.gruvbox-gtk-theme";
              example = literalExpression "pkgs.yaru-theme";
              description = ''
                Package providing the custom shell theme. This package will be installed to your profile.
                If `null` then the custom shell theme is assumed to already be available.
              '';
            };
            name = mkOption {
              type = with types; str;
              default = "Gruvbox-Dark";
              defaultText = literalExpression ''"Gruvbox-Dark"'';
              example = literalExpression ''"Yaru"'';
              description =
                "Name of the custom shell theme within the package.";
            };
          };
        }];
      });
    default = null;
  };
  config = lib.mkMerge [
    (lib.mkIf (cfg.shellTheme != null) {
      home.packages =
        lib.mkIf (cfg.shellTheme.package != null) [ cfg.shellTheme.package ];
      dconf.settings."org/gnome/shell/extensions/user-theme".name =
        cfg.shellTheme.name;
    })
    (lib.mkIf (cfg.gtkAppTheme != null || cfg.gtkIconTheme != null) {
      gtk.enable = true;
    })
  ];
}