{ ... }: {
  flake.nixosModules.hardware-acceleration = { pkgs, ... }: {
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
  };
}
