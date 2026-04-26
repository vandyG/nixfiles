{ config, pkgs, lib, ... }:

let
  src = ./templates/catppuccin-mocha-blue.ini;
in
{
  home.file = {
    ".config/copyq/themes/catppuccin-mocha-blue.ini" = {
      source = config.lib.file.mkOutOfStoreSymlink src;
    };
  };
}