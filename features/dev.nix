{ ... }: {
  flake.nixosModules.dev = { pkgs, lib, config, ... }: {

    # Alacritty configuration via XDG
    environment.etc."alacritty/alacritty.toml".text = ''
      [window]
      padding = { x = 20, y = 20 }
      opacity = 1.0

      [colors.primary]
      background = "#000000"
      foreground = "#E31C25"

      [font]
      size = 14.0
      normal = { family = "Fixedsys Excelsior", style = "Regular" }

      [[keyboard.bindings]]
      key = "N"
      mods = "Control|Shift"
      action = "None"

      [[keyboard.bindings]]
      key = "T"
      mods = "Control|Shift"
      action = "None"
    '';

    # Tmux
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

    # Development packages
    environment.systemPackages = with pkgs; [
      alacritty
      zed-editor
      git-lfs
      gh
      nixd
      direnv
      tree
    ];

    # Git identity
    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user.email = "lucas.queiroz.sena.2005@gmail.com";
        user.name = "Lucas Queiroz Sena";
      };
    };

    # Shell tools
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    # Dynamic Linker for Zed LSPs
    programs.nix-ld.enable = true;
  };
}
