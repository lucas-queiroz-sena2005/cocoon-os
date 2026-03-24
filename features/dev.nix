{ ... }: {
  flake.nixosModules.dev = { pkgs, ... }: {
    programs.nix-ld.enable = true;
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    home-manager.users.crow = {
      programs.alacritty = {
        enable = true;
        settings = {
          window.padding = { x = 20; y = 20; };
          window.decorations = "none";
        };
      };

      programs.git = {
        enable = true;
        userName = "Lucas Queiroz Sena";
        userEmail = "lucas.queiroz.sena.2005@gmail.com";
        extraConfig = { init.defaultBranch = "main"; };
      };

      programs.tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
        terminal = "alacritty";
        extraConfig = ''
          set -g status-style bg=default,fg="#E31C25"
          set -g pane-border-style fg="#2B2B2B"
          set -g pane-active-border-style fg="#E31C25"
        '';
      };

      home.file.".config/zed/settings.json".text = builtins.toJSON {
        theme = "Base16 Black"; # Matches Stylix Void/Paper
        ui_font_size = 16;
        buffer_font_family = "Courier Prime";
        window.titlebar.show = false;
        theme_overrides = {
          background = "#000000";
        };
      };

      home.packages = with pkgs; [
        zed-editor
        firefox
        git-lfs
        gh
        nixd
        direnv
        tree
      ];
    };
  };
}
