{ config, lib, ... }:
{
  options.cocoon.niri.enable = lib.mkEnableOption "niri Wayland compositor (system) + home config";

  config = lib.mkIf config.cocoon.niri.enable {
    programs.niri.enable = true;
  };
}
