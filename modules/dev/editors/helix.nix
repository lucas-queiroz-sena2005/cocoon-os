{ ... }: {
  flake.homeModules.dev-editors-helix = { pkgs, ... }: {
    programs.helix = {
      enable = true;
      settings = {
        theme = "autumn_night";
        editor = {
          line-number = "relative";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };
      };
    };
  };
}
