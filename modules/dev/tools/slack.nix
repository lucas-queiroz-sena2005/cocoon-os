{ ... }: {
  flake.nixosModules.dev-tools-slack = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.slack ];
  };

  flake.homeModules.dev-tools-slack = { ... }: {
  };
}
