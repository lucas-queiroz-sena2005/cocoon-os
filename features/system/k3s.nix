{ ... }: {
  flake.nixosModules.k3s = { pkgs, ... }: {
    services.k3s = {
      enable = true;
      role = "server";
      # Disabling Traefik/ServiceLB
      extraFlags = toString [
        "--disable traefik"
        "--disable servicelb"
      ];
    };
    environment.systemPackages = with pkgs; [
      k3s
      kubectl
      kubernetes-helm
    ];
  };
}
