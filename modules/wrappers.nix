{ inputs, self, ... }: {
  # This enables 'flake.wrappers' and 'perSystem.wrappers'
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];

  # Global Blueprint (The definition)
  # FIX: Use '@ args' to avoid name collision with the 'pkgs' option
  flake.wrappers.docker-compose = { pkgs, ... } @ args: {
    # Reference the package set explicitly via args.pkgs
    package = args.pkgs.docker-compose;

    # FIX: Assign the string directly. No .value, no .data.
    env.DOCKER_HOST = "unix:///run/podman/podman.sock";

    # FIX: Use the 'pkgs' option (suggested by your previous evaluator log)
    # Referencing args.pkgs.docker-buildx breaks the infinite recursion.
    pkgs = [ args.pkgs.docker-buildx ];
  };

  # The Aspect (NixOS Implementation)
  flake.nixosModules.wrappers = { pkgs, ... }: {
    environment.systemPackages = [
      # Standard reference for the transposed package in self.packages
      self.packages.${pkgs.stdenv.hostPlatform.system}.docker-compose
      pkgs.docker-buildx
    ];
  };
}
