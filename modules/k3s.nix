{ ... }: {
  flake.nixosModules.k3s = { pkgs, ...}: {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = "--node-ip 127.0.0.1 --bind-address 127.0.0.1";
    };

    networking.firewall.allowedTCPPorts = [ 6443 ];
    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
    ];
  };
}
