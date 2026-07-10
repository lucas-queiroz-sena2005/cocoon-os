{ lib, ... }: {
  flake.nixosModules.system-options = { lib, ... }: {
    options.cocoon = {
      defaultTerminal = lib.mkOption {
        type = lib.types.str;
        default = "ghostty";
        description = "The default terminal emulator to use across the system.";
      };
      defaultEditor = lib.mkOption {
        type = lib.types.str;
        default = "hx";
        description = "The default text editor.";
      };
    };
  };

  flake.homeModules.system-options = { lib, ... }: {
    options.cocoon = {
      defaultTerminal = lib.mkOption {
        type = lib.types.str;
        default = "ghostty";
        description = "The default terminal emulator.";
      };
      defaultEditor = lib.mkOption {
        type = lib.types.str;
        default = "hx";
        description = "The default text editor.";
      };
    };
  };
}
