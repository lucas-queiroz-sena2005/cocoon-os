{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
    ./packages.nix
    ./wrapper-defs.nix
    ./discover.nix
    ./hosts.nix
  ];
}
