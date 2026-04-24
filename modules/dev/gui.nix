{ ... }: {
  # Added inputs to access the Zen flake
  flake.nixosModules.dev-gui = { pkgs, inputs, ... }: {
    environment.systemPackages = [
      pkgs.zed-editor
      pkgs.bitwarden-desktop
      pkgs.nixd
      pkgs.librewolf
      pkgs.vesktop # Replaced obsidian with discord/vesktop
      inputs.zen-browser.packages."${pkgs.system}".default
    ];

    programs.nix-ld.enable = true;
  };

  flake.homeModules.dev-gui = { ... }: {
    xdg.configFile."zed/settings.json".text = builtins.toJSON {
      vim_mode = true;
      icon_theme = "Zed (Default)";
      ui_font_size = 20;
      ui_font_family = "monospace";
      buffer_font_size = 18;
      buffer_font_family = "monospace";
      "features" = {
        "inline_completion_provider" = "none";
      };
      "assistant" = {
        "enabled" = false;
        "version" = "2";
      };
      theme = {
        mode = "dark";
        light = "One Light";
        dark = "Rosé Pine";
      };
    };

    xdg.configFile."vesktop/settings/quickCss.css".text = ''
      @import url("https://rosepinetheme.github.io/discord/rose-pine.css");
    '';

    programs.alacritty = {
      enable = true;
      settings = {
        window = { padding = { x = 10; y = 10; }; dynamic_title = true; };
        selection.save_to_clipboard = true;
        font = {
          normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
          size = 14.0;
        };

        # Rosé Pine Palette
        colors = {
          primary = {
            foreground = "#e0def4";
            background = "#191724";
            dim_foreground = "#908caa";
            bright_foreground = "#e0def4";
          };
          cursor = {
            text = "#e0def4";
            cursor = "#524f67";
          };
          vi_mode_cursor = {
            text = "#e0def4";
            cursor = "#524f67";
          };
          search = {
            matches = {
              foreground = "#908caa";
              background = "#26233a";
            };
            focused_match = {
              foreground = "#191724";
              background = "#ebbcba";
            };
          };
          hints = {
            start = {
              foreground = "#908caa";
              background = "#1f1d2e";
            };
            end = {
              foreground = "#6e6a86";
              background = "#1f1d2e";
            };
          };
          line_indicator = {
            foreground = "#e0def4";
            background = "#1f1d2e";
          };
          footer_bar = {
            foreground = "#e0def4";
            background = "#1f1d2e";
          };
          selection = {
            text = "#e0def4";
            background = "#403d52";
          };
          normal = {
            black = "#26233a";
            red = "#eb6f92";
            green = "#31748f";
            yellow = "#f6c177";
            blue = "#9ccfd8";
            magenta = "#c4a7e7";
            cyan = "#ebbcba";
            white = "#e0def4";
          };
          bright = {
            black = "#6e6a86";
            red = "#eb6f92";
            green = "#31748f";
            yellow = "#f6c177";
            blue = "#9ccfd8";
            magenta = "#c4a7e7";
            cyan = "#ebbcba";
            white = "#e0def4";
          };
          dim = {
            black = "#6e6a86";
            red = "#eb6f92";
            green = "#31748f";
            yellow = "#f6c177";
            blue = "#9ccfd8";
            magenta = "#c4a7e7";
            cyan = "#ebbcba";
            white = "#e0def4";
          };
        };
      };
    };
  };
}
