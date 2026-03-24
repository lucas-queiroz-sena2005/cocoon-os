{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    # Direct reference to the official Noctalia build
    packages.noctalia-wrapped = inputs.noctalia.packages.${pkgs.system}.default;
  };

  flake.nixosModules.noctalia = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.self.packages.${pkgs.system}.noctalia-wrapped
    ];
  };
}
