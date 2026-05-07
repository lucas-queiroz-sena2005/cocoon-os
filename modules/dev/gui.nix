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
      };
    };
  };
}
