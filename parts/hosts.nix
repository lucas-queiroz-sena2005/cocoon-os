{ self, inputs, ... }:
{
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
    };
    modules = [
      ../hosts/thinkpad/configuration.nix
      ../profiles/common.nix
      ../profiles/laptop.nix
      self.nixosModules.cocoon
    ];
  };
}
