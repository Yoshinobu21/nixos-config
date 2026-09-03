{ pkgs, lib, ... }:

{
  imports = [
    ../../modules/core
    ../../modules/services
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-homelab";
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;

  # 1. Intel Microcode Updates (Fixes SRBDS, Meltdown/Spectre mitigations & CPU stability)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  # 2. Intel HD Graphics 4000 (Ivy Bridge) VA-API QuickSync Acceleration for Jellyfin
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver # Driver for 3rd Gen Ivy Bridge HD 4000
      libvdpau-va-gl
    ];
  };

  # 3. CPU Frequency Governor (Cool, quiet, energy-efficient 24/7 homelab operation)
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
}
