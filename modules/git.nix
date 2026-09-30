{ config, pkgs, lib, ... }:

let
  # NOTE: builtins.pathExists/getEnv are impure and always resolve to false
  # under flake (pure) evaluation, so the signing key path must not be
  # conditioned on a filesystem check at build time.
  sshKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
in

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "vandyG";
        email = "vandy.goel23@gmail.com";
        signingKey = sshKey;
      };

      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };

      core = {
        editor = "code --wait";
        pager = "delta";
      };

      gpg = {
        format = "ssh";
      };

      commit = {
        gpgsign = true;
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
