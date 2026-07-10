{ ... }: {
  flake.nixosModules.apps-bitwarden = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.bitwarden-desktop ];
  };
  flake.homeModules.apps-bitwarden = {};
}
