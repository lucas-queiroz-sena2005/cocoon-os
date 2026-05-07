{ ... }: {
  flake.homeModules.dev-editors-helix = { pkgs, ... }: {
    programs.helix = {
      enable = true;
      settings = {
        editor = {
          soft-wrap.enable = true;
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
