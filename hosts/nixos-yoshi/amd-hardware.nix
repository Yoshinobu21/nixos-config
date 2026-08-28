{ config, lib, pkgs, ... }:

{
  # 1. CPU Microcode Updates
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;

  # 2. Force load the AMD GPU kernel module early in the boot process
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # 3. Enable proprietary firmware
  hardware.enableRedistributableFirmware = true;

  # 4. Graphics Drivers (RADV is enabled by default in Mesa)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    
    # Extra packages for AMD hardware acceleration / OpenCL
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
}
