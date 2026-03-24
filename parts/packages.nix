{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        cocoon-noctalia-env = pkgs.symlinkJoin {
          name = "cocoon-noctalia-env";
          paths = [
            inputs.noctalia.packages.${system}.default
            pkgs.xwayland-satellite
            pkgs.wl-clipboard
          ];
        };

        cocoon-container-tools = pkgs.symlinkJoin {
          name = "cocoon-container-tools";
          paths = with pkgs; [
            dive
            podman-tui
            docker-compose
          ];
        };

        cocoon-k8s-tools = pkgs.symlinkJoin {
          name = "cocoon-k8s-tools";
          paths = with pkgs; [
            k3s
            kubectl
            kubernetes-helm
          ];
        };
      };
    };
}
