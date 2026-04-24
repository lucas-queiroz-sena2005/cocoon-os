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
        opener = {
          edit = [
            { run = "hx \"$@\""; block = true; for = "unix"; desc = "Edit with Helix"; }
          ];
        };
        open = {
          rules = [
            { mime = "text/*"; use = "edit"; }
          ];
        };
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
