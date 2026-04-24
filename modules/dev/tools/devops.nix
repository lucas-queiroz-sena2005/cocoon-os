{ ... }: {
  flake.nixosModules.dev-tools-devops = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      k9s
      terraform
      trivy # Security scanner for containers/IaC
      stern # Multi-pod log tailing
      gemini-cli
    ];
  };

  flake.homeModules.dev-tools-devops = { ... }: {
    # Home-specific DevOps config could go here, like Kubeconfig contexts
  };
}
