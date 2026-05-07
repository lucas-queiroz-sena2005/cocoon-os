{ pkgs, ... }: {
  flake.homeModules.dev-shell-bash = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      
      # Modern Bash Ricing (Syntax Highlighting & Better Completion)
      initExtra = ''
      '';
    };

    # FZF integration for better completion
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
