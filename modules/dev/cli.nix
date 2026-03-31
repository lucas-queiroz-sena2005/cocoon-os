{ pkgs, ... }: {
  flake.nixosModules.dev-cli = { pkgs, ... }: {
    # System-wide logic that doesn't need Home Manager
    environment.systemPackages = with pkgs; [
      ripgrep
      fd
      jq
      tealdeer
      manix
      wl-clipboard
    ];

    # Home Manager configuration for the user 'crow'
    home-manager.users.crow = {
      home.stateVersion = "25.11"; # Matches your system state

      programs = {
        # Navigation with 'cd' alias
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          options = [ "--cmd cd" ];
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        # Previewers & Interactive Search (Fixes your previous error)
        bat.enable = true;
        fzf = {
          enable = true;
          defaultOptions = [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
        };

        # Monitoring with Vim keys
        btop = {
          enable = true;
          settings = {
            color_theme = "default";
            vim_keys = true;
          };
        };

        # Terminal Workspace
        tmux = {
          enable = true;
          keyMode = "vi";
          shortcut = "a"; #
          baseIndex = 1;
          escapeTime = 0; #
          extraConfig = ''
            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            unbind '"'
            unbind %

            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R
          '';
        };

        # Neovim (Everything through Nix)
        neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          extraConfig = ''
            set clipboard+=unnamedplus
            set number relativenumber
            set shiftwidth=2
            set expandtab
            set cursorline
          '';
        };

        # Retro Aesthetic Prompt
        starship = {
          enable = true;
          settings = {
            add_newline = false;
            line_break.disabled = true;
            character = {
              success_symbol = "[>>](bold green)";
              error_symbol = "[>>](bold red)";
            };
            nix_shell.symbol = "λ ";
            git_branch.symbol = "󱄅 ";
          };
        };

        # Shell completion / listing options
        bash = {
          enable = true;
          enableCompletion = true;
          shellAliases = {
            ls = "eza --icons --group-directories-first";
            ll = "eza -lh --icons --git --group-directories-first";
            la = "eza -a --icons --group-directories-first";
            tree = "eza --tree --icons";

            cat = "bat --style=plain --paging=never";
            preview = "bat --style=full --paging=always";
            grep = "rg";
            find = "fd";
            top = "btop";

            help = "tldr";
            opt = "manix";

            nr = "sudo nixos-rebuild switch --flake .#thinkpad"; #
            ns = "nix-shell -p";
            nd = "nix develop -c $SHELL";

            ta = "tmux attach || tmux new-session"; #
            tl = "tmux list-sessions";
          };
        };
      };
    };
  };
}
