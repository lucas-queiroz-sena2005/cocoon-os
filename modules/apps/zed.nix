{ ... }: {
  flake.nixosModules.apps-zed = { pkgs, ... }: {
    environment.systemPackages = [ 
      pkgs.zed-editor 
      pkgs.nixd 
    ];
  };

  flake.homeModules.apps-zed = { ... }: {
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
        mode = "light";
        light = "Gruvbox Light";
        dark = "Gruvbox Dark";
      };
    };
  };
}
