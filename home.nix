# home.nix
{ config, pkgs, inputs, ... }:

{
  home.username = "yoshinobu";
  home.homeDirectory = "/home/yoshinobu";
  
  # This should match your system state version
  home.stateVersion = "26.05"; 

  programs.home-manager.enable = true;

  # Recursively map your app folders into ~/.config/
  xdg.configFile = {
  "hypr" = {
    source = ./hypr;
    recursive = true;
    force = true; # Force overwrite if it exists
  };
    "foot".source = ./foot;
    "waybar".source = ./waybar;
    "rofi".source = ./rofi;
    "nvim".source = ./nvim;
    "btop".source = ./btop;
    "cava".source = ./cava;
    "waypaper".source = ./waypaper;
  };

  # Map files and folders directly to your ~ (Home) directory
  home.file = {
    ".p10k.zsh".source = ./.p10k.zsh;
    ".tmux.conf".source = ./.tmux.conf;
    "wallpapers".source = ./wallpapers;
  };
}
