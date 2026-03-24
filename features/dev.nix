{ ... }: {
  # User level (Home Manager)
  flake.homeModules.home-dev = { pkgs, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        window.padding = { x = 20; y = 20; };
        window.decorations = "none";
      };
    };

    programs.git = {
      enable = true;
      userName = "Lucas Queiroz Sena";
      userEmail = "lucas.queiroz.sena.2005@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "alacritty";
      extraConfig = ''
        set -g status-style bg=default,fg="#E31C25"
        set -g pane-border-style fg="#2B2B2B"
        set -g pane-active-border-style fg="#E31C25"
      '';
    };

    home.packages = with pkgs; [
      zed-editor
      git-lfs
      gh
      nixd
      direnv
      tree
    ];
  };

  # System level (NixOS)
  flake.nixosModules.dev = { ... }: {
    programs.nix-ld.enable = true;

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
