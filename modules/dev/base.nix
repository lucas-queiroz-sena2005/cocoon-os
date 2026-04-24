{ ... }: {
  flake.nixosModules.dev-base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ripgrep fd jq tealdeer manix wl-clipboard bash-preexec

      # Terminal YouTube Matrix
      ytfzf
      yt-dlp
      mpv
    ];
  };

  flake.homeModules.dev-base = { cocoon, ... }: {
    # Pull from the global host-affiliated aliases passed via specialArgs
    home.shellAliases = cocoon.aliases or {};

    programs.bat.enable = true;
    programs.btop.enable = true;
    programs.zoxide = { enable = true; enableBashIntegration = true; options = [ "--cmd cd" ]; };
    programs.eza = { enable = true; enableBashIntegration = true; icons = "auto"; };
    programs.fzf = { enable = true; enableBashIntegration = true; };
  };
}
