{ config, pkgs, lib, ... }:

let
  sshKey = "${builtins.getEnv "HOME"}/.ssh/id_ed25519.pub";
in

{
  programs.git = {
    enable = true;
    userName = "vandyG";
    userEmail = "vandy.goel23@gmail.com";
  };

  programs.git.extraConfig = lib.optionalAttrs (builtins.pathExists sshKey) {
    gpg.format = "ssh";
    user.signingKey = sshKey;
    commit.gpgsign = true;
  };

}
