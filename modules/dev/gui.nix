{ ... }: {
  flake.nixosModules.dev-gui = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      zed-editor
      bitwarden-desktop
      nixd
    ];
    programs.nix-ld.enable = true;
  };
}
