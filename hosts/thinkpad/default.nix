{ self, inputs, ... }: {
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      ./hardware.nix
      self.nixosModules.dev
      self.nixosModules.containers
      self.nixosModules.k3s

      ({ pkgs, ... }: {
        # Identity
        networking.hostName = "thinkpad";
        time.timeZone = "America/Sao_Paulo";
        i18n.defaultLocale = "en_US.UTF-8";

        # Boot and Kernel
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
        boot.extraModprobeConfig = "options btusb enable_autosuspend=n";

        # Battery management
        services.power-profiles-daemon.enable = false;
        services.tlp = {
          enable = true;
          settings = {
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 80;
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            USB_AUTOSUSPEND = 0;
          };
        };

        # Desktop environment
        services.displayManager.sddm.enable = true;
        services.desktopManager.plasma6.enable = true;
        services.xserver = {
          enable = true;
          xkb = { layout = "br"; model = "pc105"; };
        };
        console.useXkbConfig = true;

        # User configuration
        users.users.crow = {
          isNormalUser = true;
          description = "crow";
          extraGroups = [ "networkmanager" "wheel" ];
        };

        # Bluetooth
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings.General.Experimental = true;
        };
        hardware.enableRedistributableFirmware = true;

        # Audio
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
          wireplumber.extraConfig."10-bluetooth-policy"."wireplumber.settings" = {
            "bluetooth.autoswitch-to-headset-profile" = false;
          };
        };

        # Keyd remap
        services.keyd = {
          enable = true;
          keyboards.default = {
            ids = [ "*" ];
            settings.main.rightcontrol = "ro";
          };
        };

        # System settings
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;
        programs.firefox.enable = true;
        programs.ssh.startAgent = true;

        system.stateVersion = "25.11";
      })
    ];
  };
}
