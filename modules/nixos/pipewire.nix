{ config, lib, ... }:
{
  options.cocoon.pipewire.enable = lib.mkEnableOption "PipeWire audio";

  config = lib.mkIf config.cocoon.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
