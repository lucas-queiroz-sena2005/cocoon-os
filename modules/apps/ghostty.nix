{ ... }: {
  flake.nixosModules.apps-ghostty = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ghostty ];
  };

  flake.homeModules.apps-ghostty = { ... }: {
    xdg.configFile."ghostty/config".text = ''
      window-padding-x = 10
      window-padding-y = 10
      window-decoration = none
      copy-on-select = true
      keybind = clear
      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = ctrl+shift+v=paste_from_clipboard
      keybind = ctrl+equal=increase_font_size:1
      keybind = ctrl+plus=increase_font_size:1
      keybind = ctrl+minus=decrease_font_size:1
      keybind = ctrl+0=reset_font_size
    '';
  };
}
