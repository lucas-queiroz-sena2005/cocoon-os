{ self, inputs, ... }: {
  flake.homeConfigurations."lucasse@ubuntu" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    extraSpecialArgs = {
      inherit inputs self;
      inherit (self) cocoon;
    };
    modules = [
      inputs.stylix.homeManagerModules.stylix
      {
        home.username = "lucasse";
        home.homeDirectory = "/home/lucasse";
        home.stateVersion = "25.11"; 

        # Configure Stylix for Home Manager (required by zellij & ghostty modules)
        stylix.enable = true;
        stylix.image = ../../../assets/wallpaper.png;
        stylix.polarity = "light";
        stylix.base16Scheme = "${inputs.nixpkgs.legacyPackages."x86_64-linux".base16-schemes}/share/themes/gruvbox-light-soft.yaml";

        stylix.fonts = {
          monospace = {
            package = inputs.nixpkgs.legacyPackages."x86_64-linux".nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font";
          };
          sizes = { terminal = 10; };
        };

        # Set Helix as default editor globally
        home.sessionVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
        };

        # Explicitly install Ghostty and wrap it for Ubuntu OpenGL
        home.packages = let
          pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        in [
          (pkgs.symlinkJoin {
            name = "ghostty-ubuntu";
            paths = [ pkgs.ghostty ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/ghostty \
                --prefix LD_LIBRARY_PATH : "/usr/lib/x86_64-linux-gnu"
            '';
          })
        ];

        # Set up aliases so commands like `tree` map to `eza`
        home.shellAliases = {
          cat = "bat --style=plain --paging=never";
          tree = "eza --tree --icons";
          ls = "eza --icons";
          cd = "z";
          y = "yazi";
          zj = "zellij";
        };
      }
      
      # Base CLI tools (eza, bat, zoxide, fd, rg, etc.)
      self.homeModules.cli-base
      self.homeModules.cli-bash
      
      # Helix Editor
      self.homeModules.dev-helix
      
      # Zellij Terminal Multiplexer
      self.homeModules.cli-zellij
      
      # Ghostty Terminal
      self.homeModules.apps-ghostty

      # Antigravity CLI
      self.homeModules.dev-antigravity-cli
    ];
  };
}
