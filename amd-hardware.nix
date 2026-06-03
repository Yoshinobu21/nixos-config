{ config, lib, pkgs, ... }:

{
  # 1. CPU Microcode Updates (Crucial for the Ryzen 5600G)
  hardware.cpu.amd.updateMicrocode = true;

  # 2. Force load the AMD GPU kernel module early in the boot process
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # 3. Enable proprietary firmware (Required for Wi-Fi, Bluetooth, and the RX 6600)
  hardware.enableRedistributableFirmware = true;

  # 4. Graphics Drivers (Ensure these are set!)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Steam
    
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
