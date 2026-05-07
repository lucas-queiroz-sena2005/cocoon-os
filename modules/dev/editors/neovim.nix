{ ... }: {
  flake.homeModules.dev-editors-neovim = { pkgs, ... }: {
    programs.neovim = {
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
  };
}
