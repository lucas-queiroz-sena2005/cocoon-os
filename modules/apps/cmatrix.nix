{ pkgs, ... }: {
  flake.homeModules.apps-cmatrix = { pkgs, ... }:
  {
    home.packages = with pkgs; [ ];
  };
}
