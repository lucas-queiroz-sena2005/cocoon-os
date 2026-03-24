{ pkgs, ... }:

{
  # System-wide packages for development
  environment.systemPackages = with pkgs; [
    zed-editor       # High-performance Rust-based editor
    git              # Version control
    git-lfs          # Large file support
    gh               # GitHub CLI
    nixd             # Nix Language Server for Zed
    direnv           # Auto-load environments when entering directories
    zoxide
    tree
  ];

  # Enable nix-ld: Crucial for Zed's auto-downloaded LSPs to work on NixOS
  programs.nix-ld.enable = true;

  # Git default configuration (Optional but recommended)
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      
      user.email = "lucas.queiroz.sena.2005@gmail.com";
      user.name = "Lucas Queiroz Sena";
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true; # Or zsh/fish if you use them
  };
}
