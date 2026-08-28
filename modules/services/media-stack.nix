{ ... }:

{
  # Firewall rules for Media & Automation Stack
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80    # Nginx Proxy Manager (HTTP)
      443   # Nginx Proxy Manager (HTTPS)
      81    # NPM Admin WebUI
      8096  # Jellyfin Web & Streaming
      8989  # Sonarr (TV)
      7878  # Radarr (Movies)
      9696  # Prowlarr (Indexers)
      6767  # Bazarr (Subtitles)
      5055  # Jellyseerr (Requests)
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
