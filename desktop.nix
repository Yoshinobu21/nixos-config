# desktop.nix - AMD BARE METAL SPECIFIC
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration-desktop.nix # You will generate this on the Live USB
  ];

  networking.hostName = "nixos-desktop";

  # 1. CPU Microcode Updates (Crucial for the Ryzen 5600G)
  hardware.cpu.amd.updateMicrocode = true;

  # 2. Force load the AMD GPU kernel module early in the boot process
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # 3. Enable proprietary firmware (Required for Wi-Fi, Bluetooth, and the RX 6600)
  hardware.enableRedistributableFirmware = true;

  # 4. AMD Graphics Drivers (Crucial for Wayland and Steam)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
    
    # Extra packages for AMD hardware acceleration
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
    ];
    # For 32-bit gaming
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
}
