{ pkgs, ... }:

{
  imports = [
    ../../modules/core
    ../../modules/desktop
    ./hardware-configuration.nix
    ./amd-hardware.nix
  ];

  networking.hostName = "nixos-yoshi";
  nixpkgs.hostPlatform = "x86_64-linux";
}
