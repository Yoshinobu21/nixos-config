{ pkgs, ... }:

{
  # Bootloader defaults
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Localization & Timezone
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Global System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    eza
    fzf
    zoxide
    zsh-powerlevel10k
    psmisc
    ripgrep
    tree
    htop
    btop
    jq
  ];

  # Environment Variables
  environment.variables = {
    NODE_OPTIONS = "--max-old-space-size=16000";
    DOTNET_ROOT = "$HOME/.dotnet";
    BUN_INSTALL = "$HOME/.bun";
  };

  system.stateVersion = "26.05";
}
