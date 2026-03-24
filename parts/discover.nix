{ lib, ... }:
let
  scan = import ../lib/scan.nix { inherit lib; };
in
{
  flake.nixosModules.cocoon = {
    imports = scan.scanDir ../modules/nixos;
  };
}
