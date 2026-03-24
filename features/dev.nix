{ ... }: {
  flake.nixosModules.dev = { pkgs, ... }: {

    # Alacritty configuration
    environment.etc."alacritty/alacritty.toml".text = ''
      [window]
      padding = { x = 20, y = 20 }
      opacity = 1.0

      [colors.primary]
      background = "#000000"
      foreground = "#E31C25"

      [font]
      size = 13.0
      normal = { family = "Courier Prime", style = "Regular" }

      [[keyboard.bindings]]
      key = "N"
      mods = "Control|Shift"
      action = "None"

      [[keyboard.bindings]]
      key = "T"
      mods = "Control|Shift"
      action = "None"
    '';

    # Multiplier
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

    # Development tools
    environment.systemPackages = with pkgs; [
      alacritty
      zed-editor
      git-lfs
      gh
      nixd
      direnv
      tree
    ];

    # Ink
    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user.email = "lucas.queiroz.sena.2005@gmail.com";
        user.name = "Lucas Queiroz Sena";
      };
    };

    # Navigation
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.nix-ld.enable = true;
  };
}
