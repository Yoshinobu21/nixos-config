{ ... }:

{
  imports = [
    ./default.nix
  ];

  # Headless Server CLI configuration mappings
  xdg.configFile = {
    "nvim".source = ../nvim;
    "btop".source = ../btop;
  };

  home.file = {
    ".p10k.zsh".source = ../.p10k.zsh;
    ".tmux.conf".source = ../.tmux.conf;
  };
}
