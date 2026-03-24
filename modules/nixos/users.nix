{ config, lib, ... }:
{
  options.cocoon.users.enable = lib.mkEnableOption "primary interactive user";

  config = lib.mkIf config.cocoon.users.enable {
    users.users.${config.cocoon.username} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
      ];
    };
  };
}
