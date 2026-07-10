{ inputs, ... }: {
  flake.nixosModules.dev-antigravity = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.antigravity-nix.packages.${pkgs.system}.default
    ];
  };

  flake.homeModules.dev-antigravity = { pkgs, ... }: {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.system}.default
    ];
  };
}
