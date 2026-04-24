{ ... }: {
  flake.homeModules.dev-editors-helix = { pkgs, ... }: {
    programs.helix = {
      enable = true;
      settings = {
        theme = "rose_pine";
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
