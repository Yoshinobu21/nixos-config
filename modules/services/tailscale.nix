{ pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  # Recommended settings for Tailscale on NixOS
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };

  environment.systemPackages = [ pkgs.tailscale ];
}
