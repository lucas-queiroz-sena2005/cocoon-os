{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  # FIX: imports must be a flat list. collect returns that list.
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = let
      collect = s:
        if builtins.isAttrs s
        then builtins.concatLists (map collect (builtins.attrValues s))
        else [ s ];
    in collect (inputs.import-tree ./modules);
  };
}
