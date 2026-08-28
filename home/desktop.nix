{ ... }:

{
  imports = [
    ./default.nix
  ];

  # Desktop GUI dotfiles mappings
  xdg.configFile = {
    "hypr" = {
      source = ../hypr;
      recursive = true;
      force = true;
    };
    "foot".source = ../foot;
    "waybar".source = ../waybar;
    "rofi".source = ../rofi;
    "nvim".source = ../nvim;
    "btop".source = ../btop;
    "cava".source = ../cava;
    "waypaper".source = ../waypaper;
  };

  home.file = {
    ".p10k.zsh".source = ../.p10k.zsh;
    ".tmux.conf".source = ../.tmux.conf;
    "wallpapers".source = ../wallpapers;
  };
}
