{ self, inputs, ... }: {
  # DEFINE HOST-AFFILIATED ALIASES AT THE FLAKE LEVEL
  cocoon.aliases = {
    cat = "bat --style=plain --paging=never";
    grep = "rg"; 
    find = "fd"; 
    top = "btop"; 
    help = "tldr"; 
    opt = "manix";
    tree = "eza --tree --icons";
    
    # Machine specific rebuild command
    nr = "sudo nixos-rebuild switch --flake .#thinkpad";
    
    # Modern Tool Overrides
    vi = "hx";
    vim = "hx";
    ls = "eza --icons";
    cd = "z";
    
    # YouTube Matrix
    yt = "ytfzf -T chafa";

    # System Manual
    sys-help = "sys-manual";
    };
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { 
      inherit inputs self; 
      # Pass the aliases down to NixOS modules
      inherit (self) cocoon;
    };
    modules = [
      ./_configuration.nix
      ./_hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { 
          inherit inputs self; 
          inherit (self) cocoon;
        };
        home-manager.backupFileExtension = "hm-backup";
        
        home-manager.users.crow = {
          home.stateVersion = "25.11";
          imports = [
            self.homeModules.dev-base
            self.homeModules.dev-shell-nushell
            self.homeModules.dev-shell-starship
            self.homeModules.dev-editors-neovim
            self.homeModules.dev-editors-helix
            self.homeModules.dev-tools-yazi
            self.homeModules.dev-tools-devops
            self.homeModules.dev-terminal-zellij
            
            self.homeModules.dev-gui
            self.homeModules.dev-git
            self.homeModules.style-plasma
          ];
        };
      }
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.style-fonts
      self.nixosModules.style-plasma

      # Atomized System Modules
      self.nixosModules.dev-base
      self.nixosModules.dev-tools-yazi
      self.nixosModules.dev-tools-devops
      self.nixosModules.dev-terminal-zellij
      
      self.nixosModules.dev-gui
      self.nixosModules.dev-git
    ];
  };
}
