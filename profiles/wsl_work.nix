{ lib, ... }:

{
  imports = [ ./base-wsl.nix ];

  programs.git.settings.user = {
    name = lib.mkForce "vgoel_isn";
    email = lib.mkForce "vgoel@isn.com";
  };
}