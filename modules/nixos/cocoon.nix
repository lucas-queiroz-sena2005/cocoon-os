{ lib, ... }:
{
  options.cocoon.username = lib.mkOption {
    type = lib.types.str;
    default = "crow";
    description = "Primary user for Home Manager and compositor-adjacent configs.";
  };
}
