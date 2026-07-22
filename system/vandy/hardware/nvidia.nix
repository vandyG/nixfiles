# hardware/nvidia.nix
{ ... }:

{
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware.nvidia = {
    open = true;

    modesetting.enable = true;

    nvidiaSettings = true;

    powerManagement.enable = true;

    prime = {
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };

      sync.enable = true;

      amdgpuBusId = "PCI:101:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}