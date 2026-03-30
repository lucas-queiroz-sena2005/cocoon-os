{ pkgs, ... }: {
  flake.nixosModules.dev-cli = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      tmux
      zoxide
      direnv
      tree
      ripgrep
      fzf
      jq
      btop
      eza
      bat
      fd
      neovim
      starship
    ];

    programs.zoxide.enable = true;
    programs.zoxide.enableBashIntegration = true;

    environment.shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lh --icons --git --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      tree = "eza --tree --icons";

      cat = "bat --style=plain --paging=never";
      preview = "bat --style=full --paging=always";

      grep = "rg";
      find = "fd";

      nr = "sudo nixos-rebuild switch --flake .#thinkpad-coccon";
      ns = "nix-shell -p";
      nd = "nix develop -c $SHELL";

      top = "btop";

      ta = "tmux attach || tmux new-session";
      tl = "tmux list-sessions";

      vi = "nvim";
      vim = "nvim";
      v = "nvim";
    };

    # The 'bat' for 'fzf' integration logic
    environment.variables = {
      FZF_DEFAULT_OPTS = "--preview 'bat --style=numbers --color=always --line-range :500 {}'";
    };

    /*
    --- ALIAS EXPLANATION LIST ---

    ls: Uses 'eza' for colorized directory listings with icons.
    ll: Long format 'eza' showing permissions, sizes, and Git status.
    la: Show all files including hidden (dotfiles).
    tree: Recursive directory visualization using 'eza'.
    cat: Overrides standard 'cat' with 'bat' but disables headers/paging to prevent broken pipes.
    preview: Uses 'bat' with full headers and paging for reading large files.
    grep: Replaces standard 'grep' with 'ripgrep' for significantly faster recursive searches.
    find: Replaces standard 'find' with 'fd', which is faster and has saner defaults.
    nr: Shortcut for rebuilding your specific ThinkPad configuration.
    ns: Quickly enter a temporary Nix shell with a specific package.
    nd: Enter a Nix development environment using your current shell.
    top: Replaces 'top' with 'btop' for high-signal resource monitoring.
    */

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a"; # High-signal: C-a is easier to reach than C-b
      baseIndex = 1;  # ROI: Window 1 is closer to 'a' than Window 0
      escapeTime = 0; # Latency: Removes the delay after hitting ESC

      extraConfig = ''
        # Fix the selection/yank workflow to match Vim
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Consistent navigation between panes
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
      '';
    };



    /*
    --- TMUX & ALIAS ADDITIONS ---

    programs.tmux.keyMode: Forces vi-style keybindings for copy-mode and command line.
    programs.tmux.shortcut: Sets the prefix to Ctrl-a (easier for home-row users).
    programs.tmux.escapeTime: Eliminates the delay for the ESC key, crucial for Vim users.
    bind-key v/y: Replicates Vim's visual selection and yank behavior within tmux buffers.
    bind h/j/k/l: Enables home-row pane navigation without using arrow keys.
    ta: High-speed session recovery; attaches to an existing session or spawns a new one.
    tl: Quick inspection of active background terminal sessions.
    */

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        line_break.disabled = true;
        nix_shell.symbol = "❄️ ";
        git_branch.symbol = "🌿 ";
      };
    };
  };
}
