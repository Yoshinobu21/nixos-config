{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      open
      prefix-highlight
      resurrect
      continuum
      tmux-thumbs
      tmux-fzf
      vim-tmux-navigator
      tokyo-night-tmux
    ];
    extraConfig = ''
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '1'
      set -g @resurrect-capture-pane-contents 'on'
    '';
  };
}
