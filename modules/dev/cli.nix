{ ... }: {
  flake.nixosModules.dev-cli = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ripgrep fd jq tealdeer manix wl-clipboard bash-preexec

      # Terminal YouTube Matrix
      ytfzf
      yt-dlp
      mpv
      ueberzugpp # Allows terminal image previews for thumbnails
    ];

    home-manager.users.crow = {...}: {
      home.stateVersion = "25.11";

      programs = {
        zoxide = { enable = true; enableBashIntegration = true; options = [ "--cmd cd" ]; };
        eza = { enable = true; enableBashIntegration = true; icons = "auto"; };

        # Fuzzy Finder: Hijacks Bash Tab Completion
        fzf = {
          enable = true;
          enableBashIntegration = true;
        };

        bash = {
          enable = true;
          enableCompletion = true;
          bashrcExtra = ''
            [[ $- == *i* ]] && source ${pkgs.bash-preexec}/share/bash/bash-preexec.sh

            # ytfzf configuration
            export YTFZF_PREF="bestvideo[height<=?1080]+bestaudio/best"
            export YTFZF_ENABLE_FZF_DEFAULT_OPTS=1
          '';
          shellAliases = {
            cat = "bat --style=plain --paging=never";
            preview = "bat --style=full --paging=always";
            grep = "rg"; find = "fd"; top = "btop"; help = "tldr"; opt = "manix";
            nr = "sudo nixos-rebuild switch --flake .#thinkpad";
            ns = "nix-shell -p"; nd = "nix develop -c $SHELL";
            ta = "tmux attach || tmux new-session"; tl = "tmux list-sessions";
            tree = "eza --tree --icons"; zed = "zeditor";

            # YouTube Aliashttps://github.com/lucas-queiroz-sena2005/cocoon-os/tree/refactor/home-manager
            yt = "ytfzf -T chafa"; # Plays in mpv, shows thumbnails in terminal
          };
        };

        bat.enable = true;
        btop.enable = true;
        starship.enable = true;
        neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          extraConfig = ''
            " System clipboard synchronization
            set clipboard+=unnamedplus

            " True black background and Vi-style cursorline
            highlight Normal guibg=#000000 ctermbg=black
            set cursorline
          '';
        };

        tmux = {
          enable = true;
          keyMode = "vi";
          baseIndex = 1;
          shortcut = "a";
          extraConfig = ''
            setw -g pane-base-index 1
            bind | split-window -h
            bind - split-window -v
            unbind '"'
            unbind %
            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R
          '';
        };
      };
    };
  };
}
