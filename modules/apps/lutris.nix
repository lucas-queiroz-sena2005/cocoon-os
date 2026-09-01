{ ... }: {
  flake.nixosModules.apps-lutris = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ 
      lutris 
      pcsx2 
    ];
  };
}
