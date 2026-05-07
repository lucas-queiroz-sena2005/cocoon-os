{ ... }: {
  flake.homeModules.layout-mechanical-systemd = { config, ... }: {
    # Zero-Trust Directory Scaffolding
    systemd.user.tmpfiles.rules = [
      # Infrastructure Node
      "d ${config.home.homeDirectory}/Infrastructure/NixOS 0755 - - - -"
      "d ${config.home.homeDirectory}/Infrastructure/Scripts 0755 - - - -"
      
      # Workspace Node
      "d ${config.home.homeDirectory}/Workspace/Engineering 0755 - - - -"
      "d ${config.home.homeDirectory}/Workspace/Knowledge 0755 - - - -"
      "d ${config.home.homeDirectory}/Workspace/Archive 0755 - - - -"
      
      # Vault Node
      "d ${config.home.homeDirectory}/Vault/Identity 0700 - - - -"
      
      # Volatile Node
      "d ${config.home.homeDirectory}/Volatile/Cache 0755 - - - -"
      "d ${config.home.homeDirectory}/Volatile/Scratch 0755 - - - -"
    ];
  };
}
