{ self, inputs, ... }: {
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      ./hardware.nix
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.dev
      self.nixosModules.style
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.hardware-acceleration

      ({ pkgs, config, ... }: {
        # Identity
        networking.hostName = "thinkpad";
        time.timeZone = "America/Sao_Paulo";
        i18n.defaultLocale = "en_US.UTF-8";

        # Boot
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # User and Home Manager Integration
        users.users.crow = {
          isNormalUser = true;
          extraGroups = [ "networkmanager" "wheel" "video" ];
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.crow = {
            home.stateVersion = "25.11";
          };
        };

        # Bluetooth
        hardware.bluetooth.enable = true;
        hardware.enableRedistributableFirmware = true;

        # Audio
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
        };

        # Keyd
        services.keyd = {
          enable = true;
          keyboards.default = {
            ids = [ "*" ];
            settings.main.rightcontrol = "ro";
          };
        };

        # Power
        services.tlp.enable = true;

        # System
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.wayland.enable = true;

        system.stateVersion = "25.11";
      })
    ];
  };
}
