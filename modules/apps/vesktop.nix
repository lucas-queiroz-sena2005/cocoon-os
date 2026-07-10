{ ... }: {
  flake.nixosModules.apps-vesktop = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vesktop ];
  };

  flake.homeModules.apps-vesktop = { lib, ... }: {
    stylix.targets.vesktop.enable = lib.mkDefault true;
  };
}
