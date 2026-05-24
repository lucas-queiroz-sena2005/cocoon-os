{ self, inputs, ... }: {
  # Host-specific aliases
  cocoon.aliases = {
    # Modern tool overrides
    cat = "bat --style=plain --paging=never";
    grep = "rg";
    find = "fd";
    top = "btop";
    help = "tldr";
    opt = "manix";
    tree = "eza --tree --icons";
    ls = "eza --icons";
    cd = "z";
    vi = "hx";
    vim = "hx";

    # System and utilities
    nr = "sudo nixos-rebuild switch --flake .#thinkpad";
    yt = "ytfzf -T chafa";
    agy = "antigravity";
    sys-help = "sys-manual";
  };

  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
      inherit (self) cocoon;
    };

    modules = [
      # Hardware and base configuration
      ./_configuration.nix
      ./_hardware-configuration.nix

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
            home.stateVersion = "25.11";
            home.sessionVariables = {
              EDITOR = "hx";
              VISUAL = "hx";
            };
            imports = [
              # System Layout
              self.homeModules.layout-mechanical-xdg
              self.homeModules.layout-mechanical-systemd

              # Core and Development
              self.homeModules.dev-base
              self.homeModules.dev-git
              self.homeModules.dev-gui

              # Shell and Terminal
              self.homeModules.dev-shell-bash
              self.homeModules.dev-shell-starship
              self.homeModules.dev-terminal-zellij

              # Editors
              self.homeModules.dev-editors-neovim
              self.homeModules.dev-editors-helix

              # Toolset
              self.homeModules.dev-tools-yazi
              self.homeModules.dev-tools-devops
              self.homeModules.dev-tools-gemini
              self.homeModules.dev-tools-antigravity
              self.homeModules.dev-tools-slack
              self.homeModules.dev-tools-firefox

              # Aesthetics
              self.homeModules.style-plasma
              self.homeModules.style-theme-ayu-evolve
            ];
          };
        };
      }

      # System-level modules
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.containers

      # Hardware/Dev features
      self.nixosModules.dev-base
      self.nixosModules.dev-gui
      self.nixosModules.dev-terminal-zellij
      self.nixosModules.dev-tools-yazi
      self.nixosModules.dev-tools-devops
      self.nixosModules.dev-tools-gemini
      self.nixosModules.dev-tools-antigravity
      self.nixosModules.dev-tools-slack

      # System aesthetics
      self.nixosModules.style-plasma
      self.nixosModules.style-theme-ayu-evolve
    ];
  };
}
