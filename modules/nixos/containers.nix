{ config, lib, pkgs, self, ... }:
{
  options.cocoon.containers.enable = lib.mkEnableOption "Podman and container tooling bundle";

  config = lib.mkIf config.cocoon.containers.enable {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.cocoon-container-tools
    ];
  };
}
