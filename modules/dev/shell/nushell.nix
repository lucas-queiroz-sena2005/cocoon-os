{ ... }: {
  flake.homeModules.dev-shell-nushell = { pkgs, ... }: {
    programs.nushell = {
      enable = true;
      # Aliases are automatically injected via cocoon.aliases in shell/aliases.nix
      extraConfig = ''
        $env.config = {
          show_banner: false,
          edit_mode: "vi",
          cursor_shape: {
            insert: "line",
            normal: "block",
            replace: "underscore",
          },
        }
      '';
    };
    
    # Still enable Bash as a fallback/login shell
    programs.bash.enable = true;
  };
}
