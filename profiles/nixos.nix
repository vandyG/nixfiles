{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    # ../modules/rclone.nix
    ../modules/alacritty.nix
    # ../modules/appearance.nix
    ../modules/vscode.nix
    ../modules/firefox.nix
    ../modules/ghostty.nix
    ../modules/stylix.nix
  ];

  # targets.genericLinux.enable is intentionally NOT set here.
  # NixOS already handles XDG_DATA_DIRS, fontconfig, and locale natively.
  # Setting it on NixOS would cause conflicts with the system environment.

  home.packages = [
    pkgs.sassc
    pkgs.gnome-themes-extra
    pkgs.stremio-linux-shell
    pkgs.gnomeExtensions.rounded-window-corners-reborn
    pkgs.discord
    pkgs.libreoffice
    pkgs.openssl
    pkgs.ente-cli
    pkgs.signal-desktop
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-extension-version-validation = true;
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };
}
