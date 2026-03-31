{ self, inputs, ... }: {
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      ./_configuration.nix
      ./_hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs self; };
        home-manager.backupFileExtension = "backup";
      }
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.style
      self.nixosModules.containers
      self.nixosModules.k3s
      self.nixosModules.dev-cli
      self.nixosModules.dev-gui
      self.nixosModules.dev-git
    ];
  };
}
