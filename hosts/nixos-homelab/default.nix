{ pkgs, ... }:

{
  imports = [
    ../../modules/core
    ../../modules/services
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-homelab";
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
}
