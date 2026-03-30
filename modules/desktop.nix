{ ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    services.xserver.enable = true; #
    services.displayManager.sddm.enable = true; #
    services.desktopManager.plasma6.enable = true; #

    security.rtkit.enable = true; #
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    }; #

    services.printing.enable = true; #
    programs.firefox.enable = true; #
  };
}
