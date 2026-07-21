{ ... }: {
  flake.nixosModules.apps-drift = { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [ drift ];
  };

}
