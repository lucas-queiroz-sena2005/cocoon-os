# modules/style.nix
{ ... }: {
  flake.nixosModules.style = { pkgs, ... }:
    let
      # Reliable fetch for a Lain-style typewriter font (Special Elite or similar)
      # We use fetchurl instead of fetchzip to avoid extraction errors
      typewriter-font = pkgs.stdenv.mkDerivation {
        pname = "lain-typewriter-font";
        version = "1.0";
        src = pkgs.fetchurl {
          url = "https://github.com/google/fonts/raw/main/apache/specialelite/SpecialElite-Regular.ttf";
          # Update this line with the 'got' hash from the error message:
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
        base16Scheme = "${pkgs.base16-schemes}/share/themes/black-metal-khold.yaml";
        targets.qt.enable = false;

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font";
          };
          serif = {
            # Use the reliable derivation
            package = typewriter-font;
            name = "Special Elite";
          };
          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };
          sizes = {
            applications = 12;
            terminal = 13;
            desktop = 10;
          };
        };

        opacity.terminal = 0.9;
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
        typewriter-font
      ];
    };
}
