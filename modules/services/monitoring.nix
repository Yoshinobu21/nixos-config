{ ... }:

let
  baseDir = "/mnt/ssd/myFiles/data";
  puid = "1000";
  pgid = "100";
  tz = "America/Sao_Paulo";
in
{
  # S.M.A.R.T. disk health monitoring daemon
  services.smartd = {
    enable = true;
    notifications.mail.enable = false;
    extraOptions = [ "-q" "never" ];
    defaults.monitored = "-a -o on -S on -s (S/../.././02|L/../../6/03) -T permissive";
  };

  # Ensure persistent data directories exist
  systemd.tmpfiles.rules = [
    "d ${baseDir}/portainer 0755 root root -"
    "d ${baseDir}/homepage 0775 yoshinobu users -"
    "d ${baseDir}/uptime-kuma 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {

    # 1. Portainer CE (Container Management)
    "portainer" = {
      image = "portainer/portainer-ce:latest";
      autoStart = true;
      ports = [
        "9000:9000"
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "${baseDir}/portainer:/data"
      ];
      extraOptions = [
        "--memory=64m"
      ];
    };

    # 2. Homepage (Homelab Dashboard)
    "homepage" = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoStart = true;
      ports = [
        "3000:3000"
      ];
      volumes = [
        "${baseDir}/homepage:/app/config"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        PUID = puid;
        PGID = pgid;
        HOMEPAGE_VAR_TITLE = "My Media Server";
        HOMEPAGE_VAR_SEARCH_PROVIDER = "google";
        HOMEPAGE_ALLOWED_HOSTS = "*";
      };
      extraOptions = [
        "--memory=150m"
      ];
    };

    # 3. Uptime Kuma (Status & Uptime Monitoring)
    "uptime-kuma" = {
      image = "louislam/uptime-kuma:1";
      autoStart = true;
      ports = [
        "3001:3001"
      ];
      volumes = [
        "${baseDir}/uptime-kuma:/app/data"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      extraOptions = [
        "--memory=256m"
      ];
    };

  };

  # Firewall rules for Dashboards and Monitoring tools
  networking.firewall.allowedTCPPorts = [
    3000  # Homepage Dashboard
    3001  # Uptime Kuma
    9000  # Portainer WebUI
  ];
}
