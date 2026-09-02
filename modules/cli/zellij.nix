{ ... }: {
  flake.nixosModules.cli-zellij = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.zellij ];
  };

  flake.homeModules.cli-zellij = { config, ... }: {
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        scrollback_editor = "hx";
        theme = "stylix";
        themes = {
          stylix = {
            fg = "#${config.lib.stylix.colors.base05}";
            bg = "#${config.lib.stylix.colors.base00}";
            black = "#${config.lib.stylix.colors.base00}";
            red = "#${config.lib.stylix.colors.base08}";
            green = "#${config.lib.stylix.colors.base0B}";
            yellow = "#${config.lib.stylix.colors.base0A}";
            blue = "#${config.lib.stylix.colors.base0D}";
            magenta = "#${config.lib.stylix.colors.base0E}";
            cyan = "#${config.lib.stylix.colors.base0C}";
            white = "#${config.lib.stylix.colors.base05}";
            orange = "#${config.lib.stylix.colors.base09}";
          };
        };
        default_layout = "compact";
        pane_frames = false;
        ui = {
          pane_frames = {
            rounded_corners = true;
          };
        };
        mouse_mode = true;
        copy_on_select = true;
        support_kitty_keyboard_protocol = true;
      };
    };
  };
}
