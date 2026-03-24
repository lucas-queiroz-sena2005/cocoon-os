{ ... }:
{
  system.stateVersion = "25.11";

  cocoon = {
    users.enable = true;
    home-manager.enable = true;
    nix-daemon.enable = true;
    bluetooth.enable = true;
    pipewire.enable = true;
    sddm.enable = true;
    stylix.enable = true;
    niri.enable = true;
    noctalia.enable = true;
    dev-system.enable = true;

    alacritty.enable = true;
    git.enable = true;
    tmux.enable = true;
    zed.enable = true;
    firefox.enable = true;
    dev-packages.enable = true;
  };
}
