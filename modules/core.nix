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

    system.stateVersion = "25.11";

    # Automated Home Garbage Collection
    # This cleans up stale backup files that block Home Manager activation.
    system.activationScripts.homeCleanup = {
      text = ''
        find /home/crow -maxdepth 1 -name "*.hm-backup" -delete
        find /home/crow -maxdepth 1 -name "*.backup" -delete
      '';
      deps = [ "users" ];
    };

    console.colors = [
      "26233a" "eb6f92" "31748f" "f6c177"
      "9ccfd8" "c4a7e7" "ebbcba" "e0def4"
      "6e6a86" "eb6f92" "31748f" "f6c177"
      "9ccfd8" "c4a7e7" "ebbcba" "e0def4"
    ];
  };
}
