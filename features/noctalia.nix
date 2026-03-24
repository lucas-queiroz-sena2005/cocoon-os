{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.noctalia-wrapped = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  flake.nixosModules.noctalia = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-wrapped
    ];
  };
}
