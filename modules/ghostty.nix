{ ... }: {
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      "theme" = "Catppuccin Mocha";
      "font-family" = "JetBrainsMono Nerd Font";
      "background-opacity" = 0.8;
      "cursor-click-to-move" = true;
      "cursor-style" = "block";
      "background-blur" = true;
      "command" = "fish";
      "window-decoration" = "none";
      "window-padding-x" = 10;
      "window-padding-y" = 6;
    };
  };
}
