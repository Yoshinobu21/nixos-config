{ pkgs, ... }:

{
  imports = [
    ../../modules/core
    ../../modules/desktop
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-vm";
  nixpkgs.hostPlatform = "x86_64-linux";

  virtualisation.virtualbox.guest.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
