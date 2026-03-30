{ inputs, self, ... }: {
  imports = [ inputs.wrapper-modules.flakeModules.default ];

  perSystem = { pkgs, ... }: {
    wrappers.packages.docker-compose = {
      basePackage = pkgs.docker-compose;
      env.DOCKER_HOST.value = "unix:///run/podman/podman.sock";
      path = [ pkgs.docker-buildx ];
    };
  };

  flake.nixosModules.wrappers = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.system}.docker-compose
      pkgs.docker-buildx
    ];
  };
}
