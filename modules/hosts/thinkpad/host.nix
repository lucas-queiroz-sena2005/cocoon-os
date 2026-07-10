{ self, inputs, ... }: {


  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
      inherit (self) cocoon;
    };

    modules = [
      # Hardware and base configuration
      ./_configuration.nix
      ./_hardware-configuration.nix

      # System Options
      self.nixosModules.system-options
      { cocoon = { defaultTerminal = "ghostty"; defaultEditor = "hx"; }; }

      # Home Manager configuration
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm-backup";
          extraSpecialArgs = {
            inherit inputs self;
            inherit (self) cocoon;
          };

          users.crow = {
            cocoon = { defaultTerminal = "ghostty"; defaultEditor = "hx"; };
            home.stateVersion = "25.11";
            home.sessionVariables = {
              EDITOR = "hx";
              VISUAL = "hx";
            };
            imports = [
              # System Layout
              self.homeModules.layout-xdg
              self.homeModules.layout-systemd

              # Core and Development
              self.homeModules.system-options
              self.homeModules.cli-base
              self.homeModules.cli-git
              self.homeModules.apps-zed
              self.homeModules.apps-bitwarden
              self.homeModules.apps-vesktop
              self.homeModules.apps-ghostty

              # Shell and Terminal
              self.homeModules.cli-bash
              self.homeModules.cli-starship
              self.homeModules.cli-zellij

              # Editors
              self.homeModules.dev-neovim
              self.homeModules.dev-helix

              # Toolset
              self.homeModules.cli-yazi
              self.homeModules.dev-devops
              self.homeModules.dev-antigravity
              self.homeModules.dev-antigravity-cli
              self.homeModules.dev-cocoon
              self.homeModules.apps-slack
              self.homeModules.apps-firefox

              # Aesthetics
              self.homeModules.style-plasma
              self.homeModules.style-gruvbox-light
            ];
          };
        };
      }

      # System-level modules
      self.nixosModules.system-core
      self.nixosModules.system-desktop
      self.nixosModules.services-containers

      # Hardware/Dev features
      self.nixosModules.cli-base
      self.nixosModules.apps-zed
      self.nixosModules.apps-bitwarden
      self.nixosModules.apps-vesktop
      self.nixosModules.apps-ghostty
      self.nixosModules.cli-zellij
      self.nixosModules.cli-yazi
      self.nixosModules.dev-devops
      self.nixosModules.dev-antigravity
      self.nixosModules.dev-antigravity-cli
      self.nixosModules.dev-cocoon
      self.nixosModules.apps-slack

      # System aesthetics
      self.nixosModules.style-plasma
      self.nixosModules.style-gruvbox-light
    ];
  };
}
