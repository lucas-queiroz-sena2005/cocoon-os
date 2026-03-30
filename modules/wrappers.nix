{ inputs, self, ... }: {
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];

  flake.wrappers.docker-compose = { pkgs, ... }: {
    imports = [ inputs.wrapper-modules.wrapperModules.base ];
    package = pkgs.docker-compose;
    env.DOCKER_HOST.value = "unix:///run/podman/podman.sock";
    path = [ pkgs.docker-buildx ];
  };

  flake.nixosModules.wrappers = { pkgs, ... }: {
    environment.systemPackages = [
      # The library transposes flake.wrappers into standard packages
      self.packages.${pkgs.stdenv.hostPlatform.system}.docker-compose
      pkgs.docker-buildx
    ];
  };
}
