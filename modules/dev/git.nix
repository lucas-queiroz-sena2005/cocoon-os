{ ... }: {
  flake.homeModules.dev-git = { pkgs, ... }: {
    home.packages = with pkgs; [
      git-lfs
      gh
    ];
    programs.git = {
      enable = true;
      settings = {
        user = {
          email = "lucas.queiroz.sena.2005@gmail.com";
          name = "Lucas Queiroz Sena";
        };
        init.defaultBranch = "main";
      };
    };
  };
}
