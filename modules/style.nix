{ ... }: {
  flake.nixosModules.style = { pkgs, lib, ... }:
    let
      typewriter-font = pkgs.stdenv.mkDerivation {
        pname = "lain-typewriter-font";
        version = "1.0";
        src = pkgs.fetchurl {
          url = "https://github.com/google/fonts/raw/main/apache/specialelite/SpecialElite-Regular.ttf";
          hash = "sha256-p3b8tM64vfA+KWdojr2tQmgN5bkafmLBfnGK4hLRS8Q=";
        };
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src $out/share/fonts/truetype/SpecialElite-Regular.ttf
        '';
      };
    in {
      stylix = {
        enable = true;
        image = ./assets/wallpaper.png;
        polarity = "dark";

        base16Scheme = {
          base00 = "000000"; base01 = "111111"; base02 = "222222"; base03 = "444444";
          base04 = "888888"; base05 = "c8c8c8"; base06 = "e0e0e0"; base07 = "ffffff";
          base08 = "990000"; base09 = "aa4400"; base0A = "888800"; base0B = "008800";
          base0C = "008888"; base0D = "004488"; base0E = "660066"; base0F = "440000";
        };

        targets.qt.enable = false;
        targets.gtk.enable = false;

        fonts = {
          monospace = { package = typewriter-font; name = "Special Elite"; };
          serif = { package = typewriter-font; name = "Special Elite"; };
          sansSerif = { package = pkgs.noto-fonts; name = "Noto Sans"; };
          sizes = { applications = 12; terminal = 14; desktop = 10; };
        };

        opacity.terminal = 1.0;
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
        typewriter-font
      ];

      # Structural Correction: Enforce strict KDE native rendering
      # Bypasses all lingering toxic configuration files in the user directory
      environment.variables = {
        QT_QPA_PLATFORMTHEME = lib.mkForce "kde";
        QT_STYLE_OVERRIDE = lib.mkForce "breeze";
      };
    };
}
