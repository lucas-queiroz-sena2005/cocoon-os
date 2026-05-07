{ ... }: {
  flake.homeModules.layout-mechanical-xdg = { config, ... }: {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;

        # XDG Redirection to the Mechanical Schema
        download    = "${config.home.homeDirectory}/Volatile/Downloads";
        documents   = "${config.home.homeDirectory}/Vault/Knowledge";
        music       = "${config.home.homeDirectory}/Vault/Media/Music";
        pictures    = "${config.home.homeDirectory}/Vault/Media/Pictures";
        videos      = "${config.home.homeDirectory}/Vault/Media/Videos";

        # Nullify legacy namespace variables
        desktop     = null;
        publicShare = null;
        templates   = null;
      };
    };
  };
}
