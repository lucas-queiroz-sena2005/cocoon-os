{ ... }: {
  flake.nixosModules.dev-gemini = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gemini-cli ];
  };

  flake.homeModules.dev-gemini = { ... }: {
  };
}
