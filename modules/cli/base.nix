{ ... }: {
  flake.nixosModules.cli-base = { pkgs, ... }: 
    let
      sys-manual = pkgs.writeShellScriptBin "sys-manual" ''
        ${pkgs.bat}/bin/bat --style=plain --paging=never --language=markdown ${../../docs/manual.md}
      '';
    in {
      environment.systemPackages = with pkgs; [
        ripgrep fd jq tealdeer manix wl-clipboard bash-preexec
        bash-completion
        sys-manual

        # Terminal YouTube Matrix
        ytfzf
        yt-dlp
        mpv
      ];
    };

  flake.homeModules.cli-base = { cocoon, lib, pkgs, ... }: {
    # Pull from the global host-affiliated aliases passed via specialArgs
    home.shellAliases = cocoon.aliases or {};

    home.activation.cleanThemeCaches = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf ~/.cache/starship ~/.cache/bat || true
    '';

    programs.bat.enable = true;
    programs.btop = {
      enable = true;
    };

    programs.zoxide = { enable = true; enableBashIntegration = true; options = [ "--cmd cd" ]; };
    programs.eza = { enable = true; enableBashIntegration = true; icons = "auto"; };
    programs.fzf = { enable = true; enableBashIntegration = true; };
  };
}
