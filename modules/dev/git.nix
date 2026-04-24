{ ... }: {
  flake.nixosModules.dev-git = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      git-lfs
      gh
    ];
  };

  flake.homeModules.dev-git = { ... }: {
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
