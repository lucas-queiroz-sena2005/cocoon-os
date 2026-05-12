{ ... }: {
  flake.nixosModules.core = { config, pkgs, ... }: {
    time.timeZone = "America/Sao_Paulo";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

    system.stateVersion = "25.11";

    # Automated Home Garbage Collection
    # This cleans up stale backup files that block Home Manager activation.
    system.activationScripts.homeCleanup = {
      text = ''
        rm -rf /home/crow/*.hm-backup
        rm -rf /home/crow/*.backup
      '';
      deps = [ "users" ];
    };

    console.useXkbConfig = true; # Use XKB config for console
  };
}
