{ config, pkgs, lib, ... }:

let
  src = ./alacritty.toml;
in
{
  home.file = {
    ".config/alacritty/alacritty.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink src;
    };
  };
}