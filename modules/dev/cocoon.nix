{ pkgs, ... }: {
  flake.nixosModules.dev-cocoon = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.writers.writePython3Bin "cocoon" {
        flakeIgnore = [ "E501" "F541" ];
      } (builtins.readFile ../../scripts/cocoon.py))
    ];
  };

  flake.homeModules.dev-cocoon = { pkgs, ... }: {
    home.packages = [
      (pkgs.writers.writePython3Bin "cocoon" {
        flakeIgnore = [ "E501" "F541" ];
      } (builtins.readFile ../../scripts/cocoon.py))
    ];
  };
}
