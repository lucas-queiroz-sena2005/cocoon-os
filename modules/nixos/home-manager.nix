{ config, lib, inputs, self, ... }:
let
  scan = import ../../lib/scan.nix { inherit lib; };
  user = config.cocoon.username;
in
{
  options.cocoon.home-manager.enable = lib.mkEnableOption "Home Manager integration" // {
    default = true;
  };

  config = lib.mkIf config.cocoon.home-manager.enable {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs self;
        cocoon = config.cocoon;
      };
      users.${user} = {
        imports = scan.scanDir ../home;
        home.stateVersion = config.system.stateVersion;
      };
    };
  };
}
