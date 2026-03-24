{ inputs, ... }: {
  flake.nixosModules.style = { config, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/data/themes/base16/schemes/classic-dark.yaml";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };

      base16Scheme = {
        base00 = "000000"; # Void
        base05 = "FFF9F0"; # Paper
        base08 = "E31C25"; # Wired Red
        base01 = "1A1A1A";
        base02 = "2B2B2B";
        base03 = "4D4D4D";
        base04 = "B0B0B0";
        base06 = "FFFFFF";
        base07 = "FDF5F7";
        base09 = "FF5C5C";
        base0A = "F0D58C";
        base0B = "88B04B";
        base0C = "84D0FF";
        base0D = "B39DDB";
        base0E = "E91E63";
        base0F = "A1887F";
      };

      fonts = {
        monospace = {
          # Typewriter aesthetic (Similar to Love Letter TW)
          package = pkgs.courier-prime;
          name = "Courier Prime";
        };
        serif = config.stylix.fonts.monospace;
        sansSerif = config.stylix.fonts.monospace;
        sizes.terminal = 13;
      };

      targets = {
        console.enable = true;
        gtk.enable = true;
      };
    };
  };
}
