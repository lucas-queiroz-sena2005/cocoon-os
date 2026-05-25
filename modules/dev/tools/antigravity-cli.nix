{ ... }: {
  flake.nixosModules.dev-tools-antigravity-cli = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.stdenv.mkDerivation {
        pname = "antigravity-cli";
        version = "1.0.2";
        src = pkgs.fetchurl {
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/linux-x64/cli_linux_x64.tar.gz";
          hash = "sha512-Ex9fODBAgpNvgeyP2pqjkRIxCQ9ao7J+rVfD3l2VwO+VsoGmwC2By4K+uEmEVQBP27YvDwknPVyEu7XnoPMwhg==";
        };
        sourceRoot = ".";
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        installPhase = ''
          install -Dm755 antigravity $out/bin/antigravity-cli
        '';
      })
    ];
  };

  flake.homeModules.dev-tools-antigravity-cli = { pkgs, ... }: {
    home.packages = [
      (pkgs.stdenv.mkDerivation {
        pname = "antigravity-cli";
        version = "1.0.2";
        src = pkgs.fetchurl {
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/linux-x64/cli_linux_x64.tar.gz";
          hash = "sha512-Ex9fODBAgpNvgeyP2pqjkRIxCQ9ao7J+rVfD3l2VwO+VsoGmwC2By4K+uEmEVQBP27YvDwknPVyEu7XnoPMwhg==";
        };
        sourceRoot = ".";
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        installPhase = ''
          install -Dm755 antigravity $out/bin/antigravity-cli
        '';
      })
    ];
  };
}
