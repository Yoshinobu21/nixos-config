{ ... }:

{
  # S.M.A.R.T. disk health monitoring daemon
  services.smartd = {
    enable = true;
    notifications.mail.enable = false;
    # -q never prevents smartd from failing when running on VMs without SMART support
    extraOptions = [ "-q" "never" ];
    defaults.monitored = "-a -o on -S on -s (S/../.././02|L/../../6/03) -T permissive";
  };

  # Firewall rules for Dashboards and Monitoring tools
  networking.firewall.allowedTCPPorts = [
    3000  # Homepage Dashboard
    3001  # Uptime Kuma
    9000  # Portainer WebUI
    9443  # Portainer HTTPS WebUI
  ];
}
