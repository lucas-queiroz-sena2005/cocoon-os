{ ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    services.xserver.enable = true; #
    services.libinput.touchpad.naturalScrolling = true;
    services.displayManager.sddm.enable = true; #
    services.desktopManager.plasma6.enable = true; #

    security.rtkit.enable = true; #
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    }; #

    services.printing.enable = true; #
    
    # Bluetooth stack support
    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.spectacle
      kdePackages.kde-cli-tools
      kdePackages.kpipewire # For screen recording/sharing integration
      kdePackages.bluedevil # Plasma Bluetooth manager
      bluez                 # Bluetooth stack
    ];
  };
}
