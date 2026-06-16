{ pkgs, ... }: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./templates/minimalist-black-hole.png;
    targets.starship.enable = false;
    targets.vscode.enable = false;
    targets.firefox.enable = false;
  };
}