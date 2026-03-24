# Thinkpad-specific hardware: firmware, input remaps, power, Intel graphics stack.
# Role profiles (`profiles/laptop.nix`) should stay machine-agnostic.
{ lib, pkgs, ... }:
{
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.rightcontrol = "ro";
    };
  };

  services.tlp.enable = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.sessionVariables = {
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
