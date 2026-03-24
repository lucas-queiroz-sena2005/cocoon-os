{ lib, cocoon, ... }:
{
  config = lib.mkIf cocoon.git.enable {
    programs.git = {
      enable = true;
      userName = "Lucas Queiroz Sena";
      userEmail = "lucas.queiroz.sena.2005@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
