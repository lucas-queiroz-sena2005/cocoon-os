{ lib, cocoon, pkgs, ... }:
{
  config = lib.mkIf cocoon.dev-packages.enable {
    home.packages = with pkgs; [
      git-lfs
      gh
      nixd
      direnv
      tree
    ];
  };
}
