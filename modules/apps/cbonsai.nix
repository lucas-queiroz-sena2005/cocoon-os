{ ... }: {
  flake.nixosModules.apps-cbonsai = { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [ cbonsai ];
  };

}
