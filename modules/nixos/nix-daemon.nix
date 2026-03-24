{ config, lib, ... }:
{
  options.cocoon.nix-daemon.enable = lib.mkEnableOption "Nix daemon settings (flakes, unfree)";

  config = lib.mkIf config.cocoon.nix-daemon.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;
  };
}
