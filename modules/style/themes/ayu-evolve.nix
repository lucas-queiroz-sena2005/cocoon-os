{ inputs, ... }: {
  # NIXOS SYSTEM LEVEL
  flake.nixosModules.style-theme-ayu-evolve = { lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      image = ../../assets/wallpaper.png;
      polarity = "dark";
      
      # Manual Base16 mapping of ayu-evolve (Helix variant)
      # Pushing contrast and vibrancy to match the "it-is-ayu" reference
      base16Scheme = {
        scheme = "Ayu Evolve";
        author = "crow";
        base00 = "020202";
        base01 = "111111";
        base02 = "1c1c1c";
        base03 = "5c6773";
        base04 = "bfbdb6";
        base05 = "dedede";
        base06 = "f0f0f0";
        base07 = "ffffff";
        base08 = "f07178";
        base09 = "59c2ff";
        base0A = "cfca0d";
        base0B = "aad94c";
        base0C = "73b8ff";
        base0D = "ff8732";
        base0E = "d2a6ff";
        base0F = "ff8732";
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        # Set main font back to JetBrainsMono
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
  flake.homeModules.style-theme-ayu-evolve = { config, lib, inputs, pkgs, ... }: {
    # Set GTK icon theme correctly at the home-manager level
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    # This activation script runs *after* the one in plasma.nix to ensure
    # the stylix theme is applied correctly to KDE Plasma.
    home.activation.applyStylixPlasmaTheme = lib.hm.dag.entryAfter ["applyPlasmaAesthetics"] ''
      PATH="${pkgs.kdePackages.plasma-workspace}/bin:${pkgs.kdePackages.kconfig}/bin:${pkgs.papirus-folders}/bin:$PATH"
      # The script in modules/style/plasma.nix forcefully resets the color scheme to BreezeDark.
      # We must run this command *after* that script to re-apply the correct stylix theme.
      # We use kwriteconfig6 to ensure the ColorScheme is set in kdeglobals too.
      $DRY_RUN_CMD plasma-apply-colorscheme stylix || true
      $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key ColorScheme "stylix"

      # Re-apply orange folders to ensure they stick with the theme
      $DRY_RUN_CMD papirus-folders -C orange --theme Papirus-Dark || true
    '';

    stylix.targets.helix.enable = false;
    stylix.targets.zellij.enable = false;
    
    programs.helix.settings.theme = "ayu_evolve";

    # Rice Zellij for Ayu Evolve
    programs.zellij.settings = {
      theme = "ayu-evolve-rice";
      themes.ayu-evolve-rice = {
        # High-contrast vibrant palette (Ayu Evolve)
        bg = [ 2 2 2 ];
        fg = [ 255 255 255 ]; # Unselected items white
        black = [ 13 13 13 ];
        red = [ 255 51 51 ];
        # Current Pane/Selected: Orange
        green = [ 255 135 50 ]; 
        yellow = [ 207 202 13 ];
        blue = [ 89 194 255 ];
        magenta = [ 210 166 255 ];
        cyan = [ 115 184 255 ];
        white = [ 255 255 255 ];
        orange = [ 170 217 76 ]; # Swap: Orange value is now green
      };
    };
  };
}
