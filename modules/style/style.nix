{ ... }: {
  flake.nixosModules.style = { pkgs, ... }:
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
      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
        typewriter-font
      ];
    };
}
