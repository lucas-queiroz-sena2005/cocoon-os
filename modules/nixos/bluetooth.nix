{ config, lib, ... }:
{
  options.cocoon.bluetooth.enable = lib.mkEnableOption "Bluetooth stack";

  config = lib.mkIf config.cocoon.bluetooth.enable {
    hardware.bluetooth.enable = true;
  };
}
