{ ... }:

{
  imports = [
    ./ssh.nix
    ./fail2ban.nix
    ./tailscale.nix
    ./cloudflared.nix
    ./samba.nix
    ./docker.nix
    ./proxy.nix
    ./media-stack.nix
    ./monitoring.nix
    ./maintenance.nix
  ];
}
