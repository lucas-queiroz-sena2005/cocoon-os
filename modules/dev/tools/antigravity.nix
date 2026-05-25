{ inputs, ... }: {
  flake.nixosModules.dev-tools-antigravity = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.antigravity-nix.packages.${pkgs.system}.default
    ];
  };

  flake.homeModules.dev-tools-antigravity = { pkgs, ... }: {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.system}.default
    ];
  };
}
