{ ... }:

let
  baseDir = "/mnt/ssd/myFiles/data";
in
{
  # Ensure persistent data directories exist
  systemd.tmpfiles.rules = [
    "d ${baseDir}/nginx-proxy-manager/data 0755 root root -"
    "d ${baseDir}/nginx-proxy-manager/letsencrypt 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {
    "nginx-proxy-manager" = {
      image = "jc21/nginx-proxy-manager:latest";
      autoStart = true;
      ports = [
        "80:80"
        "81:81"
        "443:443"
      ];
      volumes = [
        "${baseDir}/nginx-proxy-manager/data:/data"
        "${baseDir}/nginx-proxy-manager/letsencrypt:/etc/letsencrypt"
      ];
      extraOptions = [
        "--memory=200m"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    81
    443
  ];
}
