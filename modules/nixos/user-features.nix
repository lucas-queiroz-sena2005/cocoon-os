{ lib, ... }:
{
  options.cocoon.alacritty.enable = lib.mkEnableOption "wrapped Alacritty (home)";
  options.cocoon.git.enable = lib.mkEnableOption "Git (home)";
  options.cocoon.tmux.enable = lib.mkEnableOption "wrapped tmux (home)";
  options.cocoon.zed.enable = lib.mkEnableOption "Zed editor (home)";
  options.cocoon.firefox.enable = lib.mkEnableOption "Firefox (home)";
  options.cocoon.dev-packages.enable = lib.mkEnableOption "dev CLI packages (home)";
}
