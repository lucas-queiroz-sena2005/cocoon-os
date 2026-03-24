# Shared niri config text (KDL). Safe to use from Home Manager alone — no NixOS required.
{ palette }:
''
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
          active-color "#${palette.base08}"
          inactive-color "#${palette.base02}"
      }
  }

  spawn-at-startup "noctalia-shell"
  spawn-at-startup "xwayland-satellite"

  binds {
      // Alt-based navigation (vi directions on hjkl). Shift = move / stronger actions.
      Alt+H     { focus-column-left; }
      Alt+J     { focus-window-down; }
      Alt+K     { focus-window-up; }
      Alt+L     { focus-column-right; }

      Alt+Shift+H { move-column-left; }
      Alt+Shift+J { move-window-down; }
      Alt+Shift+K { move-window-up; }
      Alt+Shift+L { move-column-right; }

      Alt+Return hotkey-overlay-title="Terminal: alacritty" { spawn "alacritty"; }
      Alt+Q     repeat=false hotkey-overlay-title="Close window" { close-window; }
      Alt+F     hotkey-overlay-title="Fullscreen" { fullscreen-window; }
      Alt+Comma     hotkey-overlay-title="Consume into column" { consume-window-into-column; }
      Alt+Period    hotkey-overlay-title="Expel from column" { expel-window-from-column; }

      Alt+E     hotkey-overlay-title="Files: Dolphin (Plasma)" { spawn "dolphin"; }
      Alt+Space hotkey-overlay-title="Run command: KRunner (Plasma)" { spawn "krunner"; }

      Alt+Print { screenshot-window; }
      Print     { screenshot; }
  }
''
