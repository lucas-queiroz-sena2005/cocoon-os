{ ... }:{
  flake.nixosModules.k3s = { pkgs, ...}: {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = "";
    };

    # Open Firewall ports for K8s API
    networking.firewall.allowedTCPPorts = [ 6443 ];

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
    ];
  };
}
