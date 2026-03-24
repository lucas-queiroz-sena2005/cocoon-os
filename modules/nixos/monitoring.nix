# Example leaf module: discovered automatically by `parts/discover.nix` — no flake or import edits.
# Enable from a profile with `cocoon.monitoring.enable = true;` (add that line to `profiles/laptop.nix`
# or another profile). Define `options.cocoon.monitoring.enable` here if you introduce toggles.
{ config, lib, ... }:
{
  options.cocoon.monitoring.enable = lib.mkEnableOption "monitoring stack (stub)";

  config = lib.mkIf config.cocoon.monitoring.enable {
    # Add services.prometheus exporters, etc.
  };
}
