{ pkgs, ... }: {
  flake.homeModules.cli-space = { pkgs, ... }:
  {
    home.packages = with pkgs; [ ];
  };
}
