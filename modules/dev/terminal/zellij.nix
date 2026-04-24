{ ... }: {
  flake.nixosModules.dev-terminal-zellij = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.zellij ];
  };

  flake.homeModules.dev-terminal-zellij = { ... }: {
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      # Nushell integration is handled via nushell module or manual alias
      settings = {
        theme = "dracula";
        pane_frames = false;
        ui.pane_frames.rounded_corners = true;
      };
    };
  };
}
