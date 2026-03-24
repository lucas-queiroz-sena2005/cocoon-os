{ ... }:
{
  flake.wrappers.alacritty =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.alacritty ];
      settings = {
        window.padding = {
          x = 20;
          y = 20;
        };
        window.decorations = "None";
      };
    };

  flake.wrappers.tmux =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.tmux ];
      sourceSensible = false;
      clock24 = true;
      modeKeys = "vi";
      terminal = "alacritty";
      configAfter = ''
        set -g status-style bg=default,fg="#E31C25"
        set -g pane-border-style fg="#2B2B2B"
        set -g pane-active-border-style fg="#E31C25"
      '';
    };
}
