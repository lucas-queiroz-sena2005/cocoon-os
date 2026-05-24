
{ ... }: {
  flake.nixosModules.dev-tools-antigravity = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.antigravity ];
  };

  flake.homeModules.dev-tools-antigravity = { pkgs, ... }: {
    home.packages = [ pkgs.antigravity ];
  };
}
