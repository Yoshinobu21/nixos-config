{ ... }:

{
  # Ensure media and share directories exist with appropriate permissions
  systemd.tmpfiles.rules = [
    "d /mnt/ssd/myFiles 0775 yoshinobu users -"
    "d /mnt/ssd/oneDriveIsis 0775 yoshinobu users -"
  ];

  services.samba = {
    enable = true;
    openFirewall = true; # Automatically opens ports 137-139, 445
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "NixOS Homelab";
        "netbios name" = "nixos-homelab";
        "security" = "user";
        "hosts allow" = "192.168. 10. 100. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "myFiles" = {
        "path" = "/mnt/ssd/myFiles";
        "browseable" = "yes";
        "writable" = "yes";
        "read only" = "no";
        "public" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
      "oneDriveIsis" = {
        "path" = "/mnt/ssd/oneDriveIsis";
        "browseable" = "yes";
        "writable" = "yes";
        "read only" = "no";
        "public" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  # Windows Network Discovery (WSDD) so Samba shares appear automatically in Windows Explorer
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
