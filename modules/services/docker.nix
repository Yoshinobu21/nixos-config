{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # Declarative OCI containers management via systemd
  virtualisation.oci-containers.backend = "docker";

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
