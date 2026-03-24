{ config, lib, pkgs, self, ... }:
{
  options.cocoon.noctalia.enable = lib.mkEnableOption "noctalia-shell (bundled Wayland helpers)";

  config = lib.mkIf config.cocoon.noctalia.enable {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.cocoon-noctalia-env
    ];
  };
}
