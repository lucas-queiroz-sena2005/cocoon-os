{ self, inputs, ... }: {
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      ./_configuration.nix
      ./_hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs self; };
        home-manager.backupFileExtension = "hm-backup";
        
        home-manager.users.crow = {
          imports = [
            self.homeModules.dev-cli
            self.homeModules.dev-gui
            self.homeModules.dev-git
            self.homeModules.style-plasma
          ];
        };
      }
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.style-fonts
      self.nixosModules.style-plasma

      self.nixosModules.dev-cli
      self.nixosModules.dev-gui
      self.nixosModules.dev-git
    ];
  };
}
