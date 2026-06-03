# vm.nix - VIRTUALBOX SPECIFIC
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration-vm.nix # Make sure you renamed the file to this!
  ];

  networking.hostName = "nixos-vm";

  # Enable VirtualBox Guest Additions
  virtualisation.virtualbox.guest.enable = true;

  # Basic graphics for the VM
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
