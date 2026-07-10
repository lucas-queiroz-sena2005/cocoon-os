{ inputs, ... }: {
  # NIXOS SYSTEM LEVEL
  flake.nixosModules.style-gruvbox-light = { lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      image = ../../assets/wallpaper.png;
      polarity = "light";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-soft.yaml";

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

  # HOME MANAGER LEVEL
  flake.homeModules.style-gruvbox-light = { config, lib, inputs, pkgs, ... }: {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Light";
      };
    };

    home.activation.applyStylixPlasmaTheme = lib.hm.dag.entryAfter ["applyPlasmaAesthetics"] ''
      PATH="${pkgs.kdePackages.plasma-workspace}/bin:${pkgs.kdePackages.kconfig}/bin:${pkgs.papirus-folders}/bin:$PATH"
      
      $DRY_RUN_CMD plasma-apply-lookandfeel -a org.kde.breeze.desktop || true
      $DRY_RUN_CMD plasma-apply-colorscheme stylix || true
      $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key ColorScheme "stylix"

      # Re-apply yellow folders to ensure they stick with the theme
      $DRY_RUN_CMD papirus-folders -C yellow --theme Papirus-Light || true
    '';
  };
}
