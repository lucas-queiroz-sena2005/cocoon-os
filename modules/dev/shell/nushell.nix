{ ... }: {
  flake.homeModules.dev-shell-nushell = { pkgs, ... }: {
    programs.nushell = {
      enable = true;
      # Aliases are automatically injected via cocoon.aliases in shell/aliases.nix
      extraConfig = ''
        $env.config = {
          show_banner: false,
          edit_mode: "vi",
          completions: {
            case_sensitive: false
            quick: true
            partial: true
            algorithm: "prefix"
          }
          cursor_shape: {
            insert: "line",
            normal: "block",
            replace: "underscore",
          },
        }
      '';
    };
  };
}
