{ pkgs, ... }:

{
  _file = ./configuration.nix;
  config ={
    # Identity & Networking
    networking.hostName = "thinkpad-coccon";
    networking.networkmanager.enable = true;

    # Bootloader & Kernel
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
    boot.extraModprobeConfig = ''
      options btusb enable_autosuspend=n
    '';

    swapDevices = [{
      device = "/var/lib/swapfile";
      size = 8192;
    }];

    # Hardware-Specific: TLP Power Management (T14 Battery Health)
    services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        USB_AUTOSUSPEND = 0;
        USB_EXCLUDE_BTUSB = 1;
        DEVICE_REINIT_ON_RESUME_DEEP_SLP = 1;
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
      };
    };

    # Hardware-Specific: Keyboard Layout & Remaps
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main.rightcontrol = "ro";
      };
    };

    services.xserver.xkb = {
      layout = "br";
      model = "pc105";
    };
    console.useXkbConfig = true;

    # Hardware-Specific: Bluetooth Behavior
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    # User Definition (Machine-Specific access)
    users.users.crow = {
      isNormalUser = true;
      description = "crow";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    # Operational Stability
    system.stateVersion = "25.11";
  };
}
