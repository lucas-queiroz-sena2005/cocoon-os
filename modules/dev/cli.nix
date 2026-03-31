# modules/dev/cli.nix
{ ... }: {
  flake.nixosModules.dev-cli = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ripgrep
      fd
      jq
      tealdeer
      manix
      wl-clipboard
      bash-preexec
    ];

    home-manager.users.crow = {
      # Use 26.05 to match your system and silence GTK4 warnings
      home.stateVersion = "26.05";

      programs = {
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          options = [ "--cmd cd" ];
        };

        eza = {
          enable = true;
          enableBashIntegration = true;
          icons = "auto";
        };

        bash = {
          enable = true;
          enableCompletion = true;
          # Fixed: proper integration for auto-suggestions
          bashrcExtra = ''
            [[ $- == *i* ]] && source ${pkgs.bash-preexec}/share/bash/bash-preexec.sh
          '';
          shellAliases = {
            cat = "bat --style=plain --paging=never";
            preview = "bat --style=full --paging=always";
            grep = "rg";
            find = "fd";
            top = "btop";
            help = "tldr";
            opt = "manix";
            nr = "sudo nixos-rebuild switch --flake .#thinkpad";
            ns = "nix-shell -p";
            nd = "nix develop -c $SHELL";
            ta = "tmux attach || tmux new-session";
            tl = "tmux list-sessions";
          };
        };

        bat.enable = true;
        fzf.enable = true;
        btop.enable = true;
        tmux.enable = true;
        neovim.enable = true;
        starship.enable = true;
      };
    };
  };
}
