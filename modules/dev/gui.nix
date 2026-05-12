{ ... }: {
  # Added inputs to access the Zen flake
  flake.nixosModules.dev-gui = { pkgs, inputs, ... }: {
    environment.systemPackages = [
      pkgs.alacritty
      pkgs.zed-editor
      pkgs.bitwarden-desktop
      pkgs.nixd
      pkgs.vesktop # Replaced obsidian with discord/vesktop
    ];

    programs.nix-ld.enable = true;
  };

  flake.homeModules.dev-gui = { config, lib, ... }: {
    stylix.targets.vesktop.enable = lib.mkDefault true;

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
        dark = "Ayu Dark";
      };
    };

    # Removed hardcoded Vesktop quickCss since Stylix handles it now

    programs.alacritty = {
      enable = true;
      settings = {
        window = { padding = { x = 10; y = 10; }; dynamic_title = true; };
        selection.save_to_clipboard = true;
      };
    };
  };
}
