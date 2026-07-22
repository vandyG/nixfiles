{ lib, ... }:

{
  imports = [ ./base-wsl.nix ];

  home.sessionVariables.NODE_EXTRA_CA_CERTS = "/mnt/c/Users/vgoel/Downloads/cert.cer";
  home.sessionVariables.NIX_SSL_CERT_FILE  = "/mnt/c/Users/vgoel/Downloads/cert.cer";

  programs.git.settings.user = {
    name = lib.mkForce "vgoel_isn";
    email = lib.mkForce "vgoel@isn.com";
  };
}