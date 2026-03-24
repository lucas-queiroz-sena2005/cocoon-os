# Niri user config only — use under Home Manager standalone (no NixOS) by importing this
# module and passing `extraSpecialArgs.cocoon = { niri.enable = true; username = "…"; };`
# or the same shape from your flake. With NixOS, `home-manager` sets `cocoon` automatically.
{ lib, pkgs, cocoon ? { niri.enable = false; }, ... }:
let
  palette = import ../common/palette.nix;
  kdl = import ../common/niri-config.nix { inherit palette; };
in
{
  config = lib.mkIf cocoon.niri.enable {
    xdg.configFile."niri/config.kdl".text = kdl;

    home.packages = with pkgs; [
      xwayland-satellite
      wl-clipboard
      kdePackages.dolphin
      kdePackages.krunner
    ];
  };
}
