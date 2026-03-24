{ lib, cocoon, self, ... }:
{
  imports = lib.optionals cocoon.tmux.enable [ self.wrapperModules.tmux ];
}
