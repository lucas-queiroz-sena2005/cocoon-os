{ pkgs, ... }:
{
  # Container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Development tools
  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    docker-compose
  ];
}

