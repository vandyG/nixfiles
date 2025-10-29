{ config, pkgs, lib, ... }:

let
  sshKey = "${builtins.getEnv "HOME"}/.ssh/id_ed25519.pub";
  sshKeyExists = builtins.pathExists sshKey;
in

{
  programs.git = {
    enable = true;
    settings = lib.recursiveUpdate
      {
        user = {
          name = "vandyG";
          email = "vandy.goel23@gmail.com";
        };
      }
      (lib.optionalAttrs sshKeyExists {
        gpg = {
          format = "ssh";
        };
        user = {
          signingKey = sshKey;
        };
        commit = {
          gpgsign = true;
        };
      });
  };
}
