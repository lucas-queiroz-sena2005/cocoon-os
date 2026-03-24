{ config, lib, ... }:
{
  options.cocoon.sddm.enable = lib.mkEnableOption "SDDM display manager (Wayland)";

  config = lib.mkIf config.cocoon.sddm.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
  };
}
