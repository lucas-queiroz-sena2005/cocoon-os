{ ... }: {
  flake.nixosModules.dev-tools-yazi = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.yazi ];
  };

  flake.homeModules.dev-tools-yazi = { pkgs, ... }: {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_by = "mtime";
          sort_reverse = true;
          linemode = "size";
        };
      };
    };
    
    # Enable image previews via ueberzugpp as per the original setup
    home.packages = [ pkgs.ueberzugpp ];
  };
}
