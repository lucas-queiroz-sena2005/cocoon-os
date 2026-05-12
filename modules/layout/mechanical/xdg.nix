{ ... }: {
  flake.homeModules.layout-mechanical-xdg = { config, ... }: {
    home.preferXdgDirectories = true;

    home.sessionVariables = {
      # Redirect stubborn tools to XDG paths
      BASH_COMPLETION_USER_FILE = "${config.xdg.configHome}/bash_completion";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      HISTFILE = "${config.xdg.stateHome}/bash_history";
    };

    xdg = {
      enable = true;
      cacheHome = "${config.home.homeDirectory}/Volatile/Cache";
      configHome = "${config.home.homeDirectory}/Infrastructure/Config";
      stateHome = "${config.home.homeDirectory}/Volatile/Cache/state";
      dataHome = "${config.home.homeDirectory}/Volatile/Cache/data";

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
