{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    stylix.url = "github:danth/stylix";
    noctalia.url = "github:noctalia-dev/noctalia-shell";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./features/niri.nix
        ./features/noctalia.nix
        ./features/style.nix
        ./features/dev.nix
        ./features/system/hardware-acceleration.nix
        ./hosts/thinkpad/default.nix
      ];
    };
}
