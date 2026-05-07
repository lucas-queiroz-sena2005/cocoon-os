{ ... }: {
  flake.nixosModules.style-fonts = { pkgs, ... }: {
    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];
  };
}
