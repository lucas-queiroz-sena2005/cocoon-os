{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = let
      # Identification logic: stop recursing if the set looks like a module
      isModule = v: builtins.isFunction v ||
                   (builtins.isAttrs v && (v ? imports || v ? config || v ? options || v ? flake || v ? perSystem));

      collect = s:
        if builtins.isAttrs s && !isModule s
        then builtins.concatLists (map collect (builtins.attrValues s))
        else [ s ];
    in collect (inputs.import-tree ./modules);
  };
}
