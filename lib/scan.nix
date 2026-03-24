# Import-tree style scan: every `*.nix` leaf in `dir` becomes an imported module (sorted).
#
# Adding a feature: drop `modules/nixos/<name>.nix` (and/or `modules/home/<name>.nix`), declare
# `options.cocoon.*.enable` there, then toggle it from `profiles/*.nix`. Do not edit `flake.nix`,
# `parts/discover.nix`, or `self.nixosModules` — discovery is automatic. (Exclude `default.nix`.)
{ lib }:
{
  scanDir =
    dir:
    let
      names = lib.attrNames (builtins.readDir dir);
      nix = lib.filter (n: lib.hasSuffix ".nix" n && n != "default.nix") names;
      sorted = lib.sort lib.lessThan nix;
    in
    map (name: import (dir + "/${name}")) sorted;
}
