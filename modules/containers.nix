{ pkgs, ... }: {
  flake.nixosModules.containers = { pkgs, ... }: {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      dive
      podman-tui
      docker-compose
      podman-compose
    ];

    # Map the standard toolchain to the user's rootless socket
    environment.variables = {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    };
  };
}
