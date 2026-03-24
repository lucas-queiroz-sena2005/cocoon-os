{ ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;

    # Global KDL Configuration
    environment.etc."xdg/niri/config.kdl".text = ''
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

      spawn-at-startup "alacritty"
      spawn-at-startup "xwayland-satellite"
      spawn-at-startup "noctalia"

      binds {
          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }

          Mod+Return { maximize-column; }
          Mod+F { fullscreen-window; }

          Mod+Q { close-window; }
          Mod+Comma { consume-window-into-column; }
          Mod+Period { expel-window-from-column; }

          Print { screenshot; }
      }
    '';

    # Portals
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = [ "gnome" ];
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      wl-clipboard
    ];
  };
}
