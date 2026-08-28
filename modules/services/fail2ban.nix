{ ... }:

{
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.1/8"
      "192.168.0.0/16"
      "10.0.0.0/8"
      "100.64.0.0/10" # Tailscale CGNAT range
    ];
  };
}
