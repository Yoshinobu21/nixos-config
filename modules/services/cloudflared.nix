{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.cloudflared ];

  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel Daemon";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      TimeoutStartSec = "15";
      Type = "notify";
      # Pulls in TUNNEL_TOKEN variable securely
      EnvironmentFile = "-/etc/cloudflared.env";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared --no-autoupdate tunnel run";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
