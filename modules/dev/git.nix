{ ... }: {
  flake.nixosModules.dev-git = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      git-lfs
      gh
    ];

    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user.email = "lucas.queiroz.sena.2005@gmail.com";
        user.name = "Lucas Queiroz Sena";
      };
    };
  };
}
