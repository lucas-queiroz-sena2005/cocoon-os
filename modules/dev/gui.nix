{ ... }: {
  flake.nixosModules.dev-gui = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      zed-editor
      bitwarden-desktop
      nixd
    ];

    home-manager.users.crow = {
      programs.alacritty = {
        enable = true;
        settings = {
          window = {
            padding = { x = 10; y = 10; };
            dynamic_title = true;
          };
          selection.save_to_clipboard = true;
        };
      };
    };

    programs.nix-ld.enable = true;
  };
}
