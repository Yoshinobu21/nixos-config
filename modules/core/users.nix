{ pkgs, inputs, ... }:

{
  users.users.yoshinobu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      neovim
      nil
      nixpkgs-fmt
      nodejs
      gcc
      inotify-tools
      fastfetch
      docker-compose
      opencode
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
    ];
  };
}
