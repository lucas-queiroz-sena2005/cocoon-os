{ pkgs, ... }: {
  flake.nixosModules.style-new-style = { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [ ];
  };

}
