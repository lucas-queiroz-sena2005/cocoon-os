{ inputs, ... }: {
  # NIXOS SYSTEM LEVEL
  # When enabled here, Stylix automatically configures Home Manager for all users.
  flake.nixosModules.style-theme-rose-pine = { lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      image = ../../assets/wallpaper.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      polarity = "dark";

      targets.qt.platform = lib.mkForce "qtct";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 10;
          terminal = 10;
          desktop = 10;
          popups = 10;
        };
      };
    };
  };

  # HOME MANAGER LEVEL (For non-NixOS or standalone use)
  flake.homeModules.style-theme-rose-pine = { inputs, ... }: {
    imports = [ inputs.stylix.homeManagerModules.stylix ];
    stylix.enable = true;
  };
}
