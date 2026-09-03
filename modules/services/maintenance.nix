{ lib, ... }:

{
  # Automatic SSD TRIM maintenance
  services.fstrim.enable = lib.mkDefault true;

  # Compressed ZRAM swap tuned for 4GB RAM
  # Compresses inactive memory pages with zstd into RAM, giving ~7GB effective usable memory
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100; # Up to 100% of RAM as compressed swap space
  };

  # EarlyOOM: Prevents kernel lockups by terminating memory-leaking processes before system freezes
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    enableNotifications = false;
  };

  # Keep systemd journal logs bounded so they do not consume disk space
  services.journald.extraConfig = ''
    SystemMaxUse=300M
    SystemMaxFileSize=30M
  '';

  # Kernel Sysctl optimizations for 4GB Server & ZRAM
  boot.kernel.sysctl = {
    # ZRAM memory tuning: proactively compress idle pages into ZRAM to keep filesystem cache fast
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;

    # Network throughput & TCP BBR congestion control
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.ip_forward" = 1;

    # File watcher limits for media servers and development
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };
}
