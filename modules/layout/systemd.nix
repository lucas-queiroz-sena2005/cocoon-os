{ ... }: {
  flake.homeModules.layout-systemd = { config, ... }: {
    # Zero-Trust Directory Scaffolding
    systemd.user.tmpfiles.rules = [ ];
  };
}
