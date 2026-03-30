{ ... }: {
  flake.nixosModules.core = { config, pkgs, ... }: {
    time.timeZone = "America/Sao_Paulo"; #
    i18n.defaultLocale = "en_US.UTF-8"; #
    nix.settings.experimental-features = [ "nix-command" "flakes" ]; #
    nixpkgs.config.allowUnfree = true; #

    users.users.crow = {
      isNormalUser = true;
      description = "crow";
      extraGroups = [ "networkmanager" "wheel" ]; #
    };
  };
}
