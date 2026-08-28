{ pkgs, ... }:

{
  services.displayManager.ly.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "yoshinobu";
  security.pam.services.login.enableGnomeKeyring = true;

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
