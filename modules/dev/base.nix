{ ... }: {
  flake.nixosModules.dev-base = { pkgs, ... }: 
    let
      sys-manual = pkgs.writeShellScriptBin "sys-manual" ''
        ${pkgs.bat}/bin/bat --style=plain --paging=never --language=markdown <<EOF
        # Cocoon OS Quick Manual

        ## Essential Aliases
        - **nr**     : Rebuild and switch system configuration (Thinkpad)
        - **ls**     : eza (modern ls with icons)
        - **cd**     : zoxide (smart directory jumping)
        - **tree**   : eza tree view
        - **y**      : yazi (terminal file manager)
        - **cat**    : bat (cat with syntax highlighting)
        - **find**   : fd (fast file search)
        - **grep**   : rg (ripgrep - fast text search)
        - **vi/vim** : Helix (modern modal editor)
        - **zj**     : Zellij (terminal multiplexer)
        - **yt**     : ytfzf (YouTube in terminal with thumbnails)
        - **top**    : btop (system monitor)
        - **help**   : tldr (simplified man pages)
        - **opt**    : manix (nix option search)
        - **sys-help**: Display this manual

        ## Architecture: Dendritic & Atomized
        - **Dendritic**: Files in 'modules/' are automatically discovered and imported.
        - **Atomized**: System (NixOS) and User (Home Manager) logic are split into separate 
          modules for maximum portability and cleanliness.
        - **Addons**: Heavy workloads like K3s or Containers are kept in 'addons/' to keep 
          the base image slim.

        ## DevOps Tools
        - **k9s**    : Kubernetes TUI
        - **kubectl**: Kubernetes CLI
        - **hx**     : Helix Editor (Primary)
        - **nu**     : Nushell (Primary Shell)
        EOF
      '';
    in {
      environment.systemPackages = with pkgs; [
        ripgrep fd jq tealdeer manix wl-clipboard bash-preexec
        sys-manual

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
