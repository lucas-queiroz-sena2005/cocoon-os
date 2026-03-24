{ config, lib, pkgs, inputs, ... }:
let
  palette = import ../common/palette.nix;
in
{
  options.cocoon.stylix.enable = lib.mkEnableOption "Stylix global theming";

  config = lib.mkIf config.cocoon.stylix.enable {
    imports = [ inputs.stylix.nixosModules.stylix ];

    # Single Stylix↔Home Manager bridge (scheme/fonts/image follow NixOS). This is built into
    # Stylix — not nix-wrapper-modules (that project wraps executables, not theme modules).
    stylix = {
      enable = true;
      image = ../../assets/wallpaper.png;
      base16Scheme = palette;
      fonts =
        let
          mono = {
            package = pkgs.tt2020;
            name = "TT2020 Style B";
          };
        in
        {
          monospace = mono;
          serif = mono;
          sansSerif = mono;
          sizes.terminal = 13;
        };
      targets = {
        console.enable = true;
        gtk.enable = true;
        firefox.enable = true;
      };
      homeManagerIntegration = {
        followSystem = true;
        autoImport = true;
      };
    };
  };
}
