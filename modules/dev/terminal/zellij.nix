{ ... }: {
  flake.nixosModules.dev-terminal-zellij = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.zellij ];
  };

  flake.homeModules.dev-terminal-zellij = { ... }: {
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        pane_frames = true;
        ui = {
          pane_frames = {
            rounded_corners = true;
          };
        };
        mouse_mode = true;
        copy_on_select = true;
      };
    };
  };
}
