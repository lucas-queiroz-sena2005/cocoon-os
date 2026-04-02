{ ... }: {
  # Added inputs to access the Zen flake
  flake.nixosModules.dev-gui = { pkgs, inputs, ... }: {
    environment.systemPackages = [
      pkgs.zed-editor
      pkgs.bitwarden-desktop
      pkgs.nixd
      pkgs.librewolf
      inputs.zen-browser.packages."${pkgs.system}".default
    ];

    home-manager.users.crow = { ... }: {
      xdg.configFile."zed/settings.json".text = builtins.toJSON {
        vim_mode = true;
        icon_theme = "Zed (Default)";
        ui_font_size = 20;
        ui_font_family = "Special Elite";
        buffer_font_size = 18;
        buffer_font_family = "monospace";
        theme = {
          mode = "dark";
          light = "One Light";
          dark = "The Dark Side";
        };
      };

      programs.alacritty = {
        enable = true;
        settings = {
          window = { padding = { x = 10; y = 10; }; dynamic_title = true; };
          selection.save_to_clipboard = true;
          font = {
            normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
            size = 14.0;
          };

          # Vibrant Retro Matrix Palette
          colors = {
            primary = {
              background = "#000000";
              foreground = "#e0e0e0";
            };
            normal = {
              black   = "#000000";
              red     = "#ff5555"; # High-visibility error red
              green   = "#50fa7b"; # CRT Phosphor green
              yellow  = "#f1fa8c"; # Electric yellow
              blue    = "#bd93f9"; # Synthwave purple
              magenta = "#ff79c6"; # Neon pink
              cyan    = "#8be9fd"; # Terminal cyan
              white   = "#bfbfbf";
            };
            bright = {
              black   = "#4d4d4d";
              red     = "#ff6e67";
              green   = "#5af78e";
              yellow  = "#f4f99d";
              blue    = "#caa9fa";
              magenta = "#ff92d0";
              cyan    = "#9aedfe";
              white   = "#e6e6e6";
            };
          };
        };
      };
    };

    programs.nix-ld.enable = true;
  };
}
