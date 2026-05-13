# hardware/asus.nix
{ pkgs, ... }:

{
  services.asusd.enable = true;
  # services.asusd.enableUserService = true;

  services.supergfxd.enable = true;

  systemd.tmpfiles.rules = [
    "d /etc/asusd 0755 root root -"
  ];

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
}