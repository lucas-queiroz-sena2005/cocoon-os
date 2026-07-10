{ ... }: {
  flake.homeModules.layout-xdg = { config, ... }: {
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
        setSessionVariables = false;

        # Returning XDG user directories to POSIX defaults
      };
    };
  };
}
