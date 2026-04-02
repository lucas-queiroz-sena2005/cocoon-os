{ self, inputs, ... }: {
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      ./_configuration.nix
      ./_hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm-backup";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs self; };
        home-manager.backupFileExtension = "backup";
      }
      self.nixosModules.core
      self.nixosModules.desktop

      self.nixosModules.style-fonts
      self.nixosModules.style-plasma

      self.nixosModules.containers
      self.nixosModules.k3s
      self.nixosModules.dev-cli
      self.nixosModules.dev-gui
      self.nixosModules.dev-git

      self.nixosModules.dev-local-ai
    ];
  };
}
