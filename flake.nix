{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ... inputs stay the same
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ lib, self, config, ... }: {
    options = {
      flake.homeModules = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.unspecified;
        default = {};
      };
      cocoon = lib.mkOption {
        type = lib.types.submodule {
          options.aliases = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = {};
          };
        };
        default = {};
      };
    };
    config = {
      flake.cocoon = config.cocoon;
      # Simple transposition: Inject cocoon from flake-parts into NixOS modules via specialArgs
      _module.args.cocoon = self.cocoon or {};

      
      flake.templates = {};
    };

    imports = let
      # Identification logic: stop recursing if the set looks like a module
      isModule = v: builtins.isFunction v ||
                   (builtins.isAttrs v && (v ? imports || v ? config || v ? options || v ? flake || v ? perSystem));

      collect = s:
        if builtins.isAttrs s && !isModule s
        then builtins.concatLists (map collect (builtins.attrValues s))
        else [ s ];
    in collect (inputs.import-tree ./modules);
  });
}
