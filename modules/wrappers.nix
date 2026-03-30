{ inputs, ... }: {
  imports = [ inputs.wrapper-modules.flakeModule ];

  perSystem = { pkgs, ... }: {
    wrappers.docker-compose = {
      basePackage = pkgs.docker-compose;
      env.DOCKER_HOST.value = "unix:///run/podman/podman.sock";
      path = [ pkgs.docker-buildx ];
    };
  };

  flake.nixosModules.wrappers = { config, pkgs, ... }: {
    environment.systemPackages = [
      config.perSystem.self.wrappers.docker-compose
      pkgs.docker-buildx
    ];
  };
}
