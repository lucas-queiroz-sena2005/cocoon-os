{ ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;

    home-manager.users.crow = {
      home.file.".config/niri/config.kdl".text = ''

        input {
            keyboard {
                xkb {
                    layout "br"
                }
            }
        }

        layout {
            gaps 16
            center-focused-column "never"
            default-column-width { proportion 0.5; }
            focus-ring { off; }
            border {
                width 2
                active-color "#E31C25"
                inactive-color "#2B2B2B"
            }
        }

        spawn-at-startup "noctalia-shell"
        spawn-at-startup "xwayland-satellite"

        binds {
            Mod+H { focus-column-left; }
            Mod+L { focus-column-right; }
            Mod+K { focus-window-up; }
            Mod+J { focus-window-down; }

            Mod+Shift+H { move-column-left; }
            Mod+Shift+L { move-column-right; }
            Mod+Shift+K { move-window-up; }
            Mod+Shift+J { move-window-down; }

            Mod+Return { spawn "alacritty"; }
            Mod+Q { close-window; }
            Mod+F { fullscreen-window; }
            Mod+Comma { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }
            Print { screenshot; }
        }
      '';

      home.packages = with pkgs; [
        xwayland-satellite
        wl-clipboard
      ];
    };
  };
}
