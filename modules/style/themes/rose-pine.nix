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
  flake.homeModules.style-theme-rose-pine = { config, lib, inputs, pkgs, ... }: {
    # Set GTK icon theme correctly at the home-manager level
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    home.activation.applyStylixPlasmaTheme = lib.hm.dag.entryAfter ["applyPlasmaAesthetics"] ''
      PATH="${pkgs.kdePackages.plasma-workspace}/bin:${pkgs.kdePackages.kconfig}/bin:${pkgs.papirus-folders}/bin:$PATH"
      $DRY_RUN_CMD plasma-apply-colorscheme stylix || true
      $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key ColorScheme "stylix"
      $DRY_RUN_CMD papirus-folders -C grey --theme Papirus-Dark || true
    '';
  };
}
