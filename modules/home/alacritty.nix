{ lib, cocoon, self, ... }:
{
  imports = lib.optionals cocoon.alacritty.enable [ self.wrapperModules.alacritty ];
}
