{ ... }:

let
  baseDir = "/mnt/ssd/myFiles";
  dataDir = "${baseDir}/data";
  moviesDir = "${baseDir}/movies";
  showsDir = "${baseDir}/shows";
  downloadsDir = "${dataDir}/downloads";

  puid = "1000";
  pgid = "100";
  tz = "America/Sao_Paulo";
in
{
  # Ensure all persistent app data, download, and media directories exist with correct permissions
  systemd.tmpfiles.rules = [
    "d ${baseDir} 0775 yoshinobu users -"
    "d ${dataDir} 0775 yoshinobu users -"
    "d ${moviesDir} 0775 yoshinobu users -"
    "d ${showsDir} 0775 yoshinobu users -"
    "d ${downloadsDir} 0775 yoshinobu users -"
    "d ${dataDir}/jellyfin/config 0775 yoshinobu users -"
    "d ${dataDir}/jellyfin/cache 0775 yoshinobu users -"
    "d ${dataDir}/qbittorrent/config 0775 yoshinobu users -"
    "d ${dataDir}/prowlarr/config 0775 yoshinobu users -"
    "d ${dataDir}/sonarr/config 0775 yoshinobu users -"
    "d ${dataDir}/radarr/config 0775 yoshinobu users -"
    "d ${dataDir}/jellyseerr/config 0775 yoshinobu users -"
    "d ${dataDir}/bazarr/config 0775 yoshinobu users -"
  ];

  # Declarative Media & Automation Containers
  virtualisation.oci-containers.containers = {

    # 1. Jellyfin (Media Server)
    "jellyfin" = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      autoStart = true;
      ports = [
        "8096:8096"
        "8920:8920"
      ];
      volumes = [
        "${dataDir}/jellyfin/config:/config"
        "${dataDir}/jellyfin/cache:/cache"
        "${moviesDir}:/movies"
        "${showsDir}:/shows"
      ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = tz;
      };
      extraOptions = [
        "--memory=512m"
        "--device=/dev/dri:/dev/dri"
      ];
    };

    # 2. qBittorrent (Download Client)
    "qbittorrent" = {
      image = "qbittorrentofficial/qbittorrent-nox:latest";
      autoStart = true;
      ports = [
        "8081:8081"
        "6881:6881/tcp"
        "6881:6881/udp"
      ];
      volumes = [
        "${dataDir}/qbittorrent/config:/config"
        "${downloadsDir}:/downloads"
      ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = tz;
        QBT_EULA = "accept";
        QBT_WEBUI_PORT = "8081";
      };
      extraOptions = [
        "--cpus=0.5"
        "--memory=300m"
      ];
    };

    # 3. Prowlarr (Indexer Manager)
    "prowlarr" = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      autoStart = true;
      ports = [
        "9696:9696"
      ];
      volumes = [
        "${dataDir}/prowlarr/config:/config"
      ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = tz;
      };
      extraOptions = [
        "--cpus=0.3"
        "--memory=256m"
      ];
    };

    # 4. FlareSolverr (Cloudflare Challenge Solver for Indexers)
    "flaresolverr" = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      autoStart = true;
      ports = [
        "8191:8191"
      ];
      environment = {
        TZ = tz;
      };
      extraOptions = [
        "--cpus=0.5"
        "--memory=512m"
      ];
    };

    # 5. Sonarr (TV Shows Automation)
    "sonarr" = {
      image = "lscr.io/linuxserver/sonarr:latest";
      autoStart = true;
      dependsOn = [
        "qbittorrent"
        "prowlarr"
      ];
      ports = [
        "8989:8989"
      ];
      volumes = [
        "${dataDir}/sonarr/config:/config"
        "${downloadsDir}:/downloads"
        "${showsDir}:/shows"
      ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = tz;
      };
      extraOptions = [
        "--cpus=0.5"
        "--memory=256m"
      ];
    };

    # 6. Radarr (Movies Automation)
    "radarr" = {
      image = "lscr.io/linuxserver/radarr:latest";
      autoStart = true;
      dependsOn = [
        "qbittorrent"
        "prowlarr"
      ];
      ports = [
        "7878:7878"
      ];
      volumes = [
        "${dataDir}/radarr/config:/config"
        "${downloadsDir}:/downloads"
        "${moviesDir}:/movies"
      ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = tz;
      };
      extraOptions = [
        "--cpus=0.5"
        "--memory=256m"
      ];
    };

    # 7. Bazarr (Subtitles Automation)
    "bazarr" = {
      image = "lscr.io/linuxserver/bazarr:latest";
      autoStart = true;
      dependsOn = [
        "sonarr"
        "radarr"
      ];
      ports = [
        "6767:6767"
      ];
      volumes = [
        "${dataDir}/bazarr/config:/config"
        "${showsDir}:/shows"
        "${moviesDir}:/movies"
      ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = tz;
      };
      extraOptions = [
        "--cpus=0.3"
        "--memory=1024m"
      ];
    };

    # 8. Jellyseerr (Media Requests)
    "jellyseerr" = {
      image = "fallenbagel/jellyseerr:latest";
      autoStart = true;
      dependsOn = [
        "sonarr"
        "radarr"
        "jellyfin"
      ];
      ports = [
        "5055:5055"
      ];
      volumes = [
        "${dataDir}/jellyseerr/config:/app/config"
      ];
      environment = {
        TZ = tz;
      };
      extraOptions = [
        "--cpus=0.3"
        "--memory=350m"
      ];
    };

  };

  # Firewall rules for Media Stack
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8096  # Jellyfin Web & Streaming
      8920  # Jellyfin HTTPS
      8989  # Sonarr
      7878  # Radarr
      9696  # Prowlarr
      8191  # FlareSolverr
      6767  # Bazarr
      5055  # Jellyseerr
      8081  # qBittorrent WebUI
      6881  # BitTorrent TCP
    ];
    allowedUDPPorts = [
      6881  # BitTorrent UDP
      1900  # Jellyfin DLNA discovery
      7359  # Jellyfin autodiscovery
    ];
  };
}
