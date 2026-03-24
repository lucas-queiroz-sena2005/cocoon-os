{ lib, cocoon, pkgs, ... }:
{
  config = lib.mkIf cocoon.zed.enable {
    home.file.".config/zed/settings.json".text = builtins.toJSON {
      theme = "Base16 Black";
      ui_font_size = 16;
      buffer_font_family = "TT2020 Style B";
      window.titlebar.show = false;
      theme_overrides = {
        background = "#000000";
      };
    };

    home.packages = [ pkgs.zed-editor ];
  };
}
