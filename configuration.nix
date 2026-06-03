# configuration.nix - SHARED CORE
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  
  # Automatically detects and symlinks identical files to save space
  nix.settings.auto-optimise-store = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  services.displayManager.ly.enable = true;

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true; 
  };

  programs.dconf.enable = true;
  services.playerctld.enable = true;
  
  # Core System Security & Dev
  security.polkit.enable = true;
  programs.direnv.enable = true;

  users.users.yoshinobu = {
    isNormalUser = true;
    extraGroups = ["wheel"]; 
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      git
      foot
      neovim
      ripgrep
      nil
      nixpkgs-fmt
      nodejs
      gcc
      thunar
      inputs.hypr-rdp.packages.${pkgs.stdenv.hostPlatform.system}.hypr-rdp
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.browser-previews.packages.${pkgs.stdenv.hostPlatform.system}.google-chrome
      vlc
      qbittorrent
      waybar
      inotify-tools
      pavucontrol
      cava
      fastfetch
      btop
      htop
      playerctl
      zscroll
      discord
      tailscale
      grim
      slurp
      dunst
      jq
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Nix Helper (nh) Configuration
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 3";
    flake = "/home/yoshinobu/nixos-config"; 
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    eza
    fzf
    zoxide
    zsh-powerlevel10k
    adwaita-icon-theme
    wl-clipboard
    cliphist
    rofi
    nwg-clipman
    wtype
    libnotify
    awww
    polkit_gnome
    psmisc
    seahorse
  ];

  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];    
 
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.variables = {
      NODE_OPTIONS = "--max-old-space-size=16000";
      DOTNET_ROOT = "$HOME/.dotnet";
      ANDROID_SDK_ROOT = "$HOME/Android";
      BUN_INSTALL = "$HOME/.bun";
  };

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

  programs.zsh = {
      enable = true;
      histSize = 10000;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      ohMyZsh = {
          enable = true;
          plugins = [ "git" ];
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

  services.openssh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.firewall.allowedTCPPorts = [ 3389 ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "yoshinobu";
  security.pam.services.login.enableGnomeKeyring = true;

  system.stateVersion = "26.05"; 
}
