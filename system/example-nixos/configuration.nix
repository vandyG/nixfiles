# NixOS system configuration — rename this directory to your machine's hostname.
#
# SETUP:
# 1. Copy this directory to system/<hostname>/
# 2. Generate hardware-configuration.nix on the target machine:
#      sudo nixos-generate-config --show-hardware-config > system/<hostname>/hardware-configuration.nix
# 3. Edit networking.hostName and time.timeZone below.
# 4. Find your GPU PCI bus IDs and fill in hardware.nvidia.prime below.
# 5. Register the host in flake.nix nixosConfigurations (see the comment there).
#
# For the Asus ROG Zephyrus G14 GA403UV (Ryzen 9 7940HS + RTX 4060 Ada Lovelace),
# there is NO dedicated nixos-hardware module for the GA403UV. Instead, compose
# from common modules in flake.nix nixosConfigurations:
#
#   nixos-hardware.nixosModules.common-cpu-amd
#   nixos-hardware.nixosModules.common-cpu-amd-pstate
#   nixos-hardware.nixosModules.common-gpu-amd
#   nixos-hardware.nixosModules.common-gpu-nvidia      # PRIME offload
#   nixos-hardware.nixosModules.common-pc-laptop
#   nixos-hardware.nixosModules.common-pc-ssd
#   ./system/<hostname>/configuration.nix
#
# Together these handle: AMD CPU + pstate, AMD iGPU (amdgpu), NVIDIA PRIME offload,
# and generic laptop power settings. asusd, supergfxd, and NVIDIA options are
# configured explicitly below.

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "myhostname"; # CHANGE ME
  networking.networkmanager.enable = true;

  # ── Locale / timezone ─────────────────────────────────────────────────────
  time.timeZone = "America/New_York"; # CHANGE ME
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users.vandy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    # Home Manager manages the shell config; fish must be listed in
    # programs.fish.enable so it appears in /etc/shells.
  };

  # Register fish in /etc/shells so Home Manager can set it as the login shell.
  programs.fish.enable = true;

  # ── GPU: AMD (iGPU) + NVIDIA RTX 4060 Ada Lovelace (dGPU) ───────────────
  #
  # The common nixos-hardware modules (added in flake.nix) provide:
  #   - hardware.graphics.enable via common-gpu-amd
  #   - hardware.nvidia.prime.offload via common-gpu-nvidia
  #   - amdgpu kernel module via common-gpu-amd
  #
  # Explicit settings below complete the NVIDIA + PRIME configuration.

  # Use the NVIDIA open-source kernel module (RTX 4060 is Ada Lovelace / Turing+,
  # open module is recommended by NVIDIA for these architectures).
  hardware.nvidia.open = true;

  # DRM kernel modesetting — required for PRIME offload and Wayland.
  hardware.nvidia.modesetting.enable = true;

  # nvidia-settings GUI utility.
  hardware.nvidia.nvidiaSettings = true;

  # Load nvidia driver (amdgpu is loaded automatically by common-gpu-amd module).
  services.xserver.videoDrivers = [ "nvidia" ];

  # Fine-grained power management: RTX 4060 fully powers off when idle (RTD3).
  # Disable if you experience crashes on suspend/resume.
  hardware.nvidia.powerManagement.finegrained = true;

  # YOU MUST set the correct PCI bus IDs for your specific unit.
  # Run: sudo lshw -c display
  # Look for "bus info: pci@0000:XX:YY.Z" for each GPU, then convert hex to
  # decimal. Example: "pci@0000:01:00.0" → nvidiaBusId = "PCI:1:0:0"
  #                   "pci@0000:04:00.0" → amdgpuBusId = "PCI:4:0:0"
  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:4:0:0"; # VERIFY with lshw — hex 04 → decimal 4
    nvidiaBusId  = "PCI:1:0:0"; # VERIFY with lshw — hex 01 → decimal 1
  };

  # Enable 32-bit graphics support (needed for Steam, Wine, Proton).
  hardware.graphics.enable32Bit = true;

  # VA-API hardware video decode for AMD iGPU.
  hardware.graphics.extraPackages = with pkgs; [ libva-vdpau-driver ];

  # ── ASUS laptop services ──────────────────────────────────────────────────
  # asusd: fan control, keyboard RGB, power profiles, battery charge limit.
  services.asusd.enable = true;

  # supergfxd: runtime GPU mode switching (Hybrid / Integrated / Dedicated)
  # without rebooting. Use `supergfxctl --mode Hybrid|Integrated|Dedicated`.
  services.supergfxd.enable = true;

  # ── PRIME offload usage ────────────────────────────────────────────────────
  # With common-gpu-nvidia, the `nvidia-offload` wrapper command is installed.
  # To run a single app on the RTX 4060:
  #   nvidia-offload <command>
  # Example: nvidia-offload steam
  # Or: __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia <command>

  # ── Nix settings ──────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages at the system level (mirrors home.nix allowUnfree).
  nixpkgs.config.allowUnfree = true;

  # ── System packages (system-wide only, user packages are in home.nix) ─────
  environment.systemPackages = with pkgs; [
    git
    vim
    pciutils   # provides lspci — useful for verifying GPU bus IDs
    lshw       # provides lshw -c display
    nvtopPackages.full  # GPU monitoring (AMD + NVIDIA)
  ];

  # ── Services ──────────────────────────────────────────────────────────────
  # asusd and supergfxd are configured in the GPU section above.
  # Add machine-specific services here (e.g. services.openssh.enable = true).

  system.stateVersion = "25.05"; # Do not change after initial install.
}
