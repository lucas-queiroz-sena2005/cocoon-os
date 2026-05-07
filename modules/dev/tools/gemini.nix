{ ... }: {
  flake.nixosModules.dev-tools-gemini = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gemini-cli ];
  };

  flake.homeModules.dev-tools-gemini = { ... }: {
  };
}
