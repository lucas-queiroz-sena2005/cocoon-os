{ config, lib, pkgs, self, ... }:
{
  options.cocoon.k3s.enable = lib.mkEnableOption "k3s single-node server and Kubernetes CLI bundle";

  config = lib.mkIf config.cocoon.k3s.enable {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = "--disable traefik --disable servicelb";
    };

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.cocoon-k8s-tools
    ];
  };
}
