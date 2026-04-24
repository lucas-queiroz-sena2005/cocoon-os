{
  description = "Standardized Engineering Docs & Project Planning Kit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    # 1. The Development Environment
    devShells = forAllSystems (system: 
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            mkdocs
            python311Packages.mkdocs-material
            glow
            marksman
            ripgrep
            fd
            gemini-cli
          ];
          shellHook = ''
            echo "🛠️  Docs-as-Code Environment Bootstrapped."
            echo "→ Run 'mkdocs serve' for live documentation preview."
            echo "→ Use 'glow' to read markdown files in the terminal."
          '';
        };
      }
    );

    # 2. The Template System
    templates.default = {
      path = ./template;
      description = "Boilerplate for High-Density Engineering Documentation";
    };
  };
}
