{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    histSize = 10000;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "docker-compose" ];
    };
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --git";
      la = "eza -a --icons";
      Ls = "ls --color";
    };
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    interactiveShellInit = ''
      setopt appendhistory sharehistory hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups
      export FZF_DEFAULT_OPTS="--bind='ctrl-j:down,ctrl-k:up'"
      eval "$(zoxide init --cmd cd zsh)"
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7dcfff,bold"
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      export PATH="$BUN_INSTALL/bin:$HOME/.local/bin:$HOME/.dotnet:$HOME/.dotnet/tools:/usr/lib/dotnet:$HOME/Android/cmdline-tools/latest/bin:$HOME/Android/platform-tools:$HOME/flutterSDK/flutter/bin:$PATH"
    '';
  };
}
