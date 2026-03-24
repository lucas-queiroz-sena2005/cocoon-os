{ lib, cocoon, pkgs, ... }:
{
  config = lib.mkIf cocoon.firefox.enable {
    home.packages = [ pkgs.firefox ];
  };
}
