# hardware/asus.nix
{ pkgs, ... }:

{
  services.asusd.enable = true;
  services.asusd.enableUserService = true;

  services.supergfxd.enable = true;

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
}