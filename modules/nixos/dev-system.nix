{ config, lib, ... }:
{
  options.cocoon.dev-system.enable = lib.mkEnableOption "system-level developer conveniences (nix-ld, zoxide)";

  config = lib.mkIf config.cocoon.dev-system.enable {
    programs.nix-ld.enable = true;
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
