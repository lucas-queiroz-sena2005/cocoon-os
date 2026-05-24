{ ... }: {
  flake.homeModules.layout-mechanical-xdg = { config, ... }: {
    home.preferXdgDirectories = true;

    xdg = {
      enable = true;
      # Reverting to standard paths for maximum compatibility and zero leakage
      cacheHome  = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome   = "${config.home.homeDirectory}/.local/share";
      stateHome  = "${config.home.homeDirectory}/.local/state";

      userDirs = {
        enable = true;
        createDirectories = true;

        # Keep XDG Redirection for personal data to the Mechanical Schema
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
