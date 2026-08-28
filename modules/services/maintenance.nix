{ lib, ... }:

{
  # Automatic SSD TRIM maintenance
  services.fstrim.enable = lib.mkDefault true;

  # Compressed ZRAM swap to prevent Out-Of-Memory freezes on homelab workloads
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Keep systemd journal logs bounded so they do not consume disk space
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFileSize=50M
  '';

  # Kernel Sysctl optimizations for server throughput, container networking, and file watching
  boot.kernel.sysctl = {
    # Network throughput & TCP BBR congestion control
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.ip_forward" = 1;

    # File watcher limits for media servers and development
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };
}
