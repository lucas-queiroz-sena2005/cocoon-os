{ ... }: {
  flake.nixosModules.apps-slack = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.slack ];
  };

  flake.homeModules.apps-slack = { ... }: {
  };
}
