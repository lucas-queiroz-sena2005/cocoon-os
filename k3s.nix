{ pkgs, ... }:

{
  # Enable K3s as a single-node server
  services.k3s = {
    enable = true;
    role = "server";
    # Disabling Traefik/ServiceLB
    extraFlags = toString [
      "--disable traefik"
      "--disable servicelb"
    ];
  };

  # Open Firewall ports for K8s API
  networking.firewall.allowedTCPPorts = [ 6443 ];

  # Install management tools
  environment.systemPackages = with pkgs; [
    kubectl    # Standard K8s CLI
    kubernetes-helm # Package manager for K8s
  ];
}
