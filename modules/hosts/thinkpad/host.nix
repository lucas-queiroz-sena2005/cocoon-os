{ self, inputs, ... }: {
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      ./_configuration.nix
      ./_hardware-configuration.nix
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.containers
      self.nixosModules.wrappers
      self.nixosModules.k3s
      self.nixosModules.dev-cli
      self.nixosModules.dev-gui
      self.nixosModules.dev-git
    ];
  };
}
