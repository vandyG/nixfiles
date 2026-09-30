# hardware/nvidia.nix
{ config, ... }:

{
  hardware.graphics.enable = true;
  # ZenScreen MB16ACV fails DP Alt Mode here; drive it over USB via DisplayLink/evdi.
  # Needs displaylink-620.zip in the Nix store first (see TROUBLESHOOT.md).
  services.xserver.videoDrivers = [
    # "displaylink"
    "nvidia"
    "amdgpu"
  ];

  # systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  # boot = {
  #   extraModulePackages = [ config.boot.kernelPackages.evdi ];
  #   initrd = {
  #     # List of modules that are always loaded by the initrd.
  #     kernelModules = [
  #       "evdi"
  #     ];
  #   };
  # };

  hardware.nvidia = {
    open = true;

    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # sync.enable = true;

      amdgpuBusId = "PCI:101@0:0:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
}
