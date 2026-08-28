{ pkgs, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.firefox.enable = true;

  # Additional desktop graphical packages
  users.users.yoshinobu.packages = with pkgs; [
    foot
    thunar
    inputs.hypr-rdp.packages.${pkgs.stdenv.hostPlatform.system}.hypr-rdp
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.browser-previews.packages.${pkgs.stdenv.hostPlatform.system}.google-chrome
    vlc
    qbittorrent
    waybar
    pavucontrol
    cava
    playerctl
    zscroll
    discord
    grim
    slurp
    dunst
    adwaita-icon-theme
    wl-clipboard
    cliphist
    rofi
    nwg-clipman
    wtype
    libnotify
    awww
    polkit_gnome
    seahorse
  ];

  networking.firewall.allowedTCPPorts = [ 3389 ];
}
