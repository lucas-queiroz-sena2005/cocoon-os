# Cocoon OS (Rework)

A highly atomized NixOS configuration using the **Dendritic Pattern**.

## Architecture: The Dendritic Pattern

This repository uses `import-tree` to automatically discover and export modules. The "dendrite" grows from the `modules/` directory:

- **Automatic Discovery**: Any file added to `modules/` is automatically imported.
- **Atomization**: Logic is split into `nixosModules` (system-wide) and `homeModules` (user-specific).
- **Agnosticism**: `homeModules` are pure and can be used on non-NixOS systems (macOS, standalone Home Manager).

## Directory Structure

- `modules/`: Core dendritic tree. Auto-scanned.
  - `core.nix`: Base system settings (locale, time, nix settings).
  - `desktop.nix`: Graphical environment (Plasma 6, SDDM, Pipewire).
  - `dev/`: Development tools (CLI, GUI, Git).
  - `style/`: Aesthetics (Fonts, Plasma styling).
  - `hosts/`: Machine-specific configurations.
- `addons/`: Heavy or optional workloads (K3s, Podman, AI). Moved here to keep the base image slim.
- `flake.nix`: Entry point and output orchestrator.

## Host Implementation Example

To create a new host, create a directory in `modules/hosts/`. Below is a template for `modules/hosts/your-host/host.nix`:

```nix
{ self, inputs, ... }: {
  flake.nixosConfigurations.your-host = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      ./_configuration.nix           # Host-specific settings
      ./_hardware-configuration.nix  # Hardware scan
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        
        # ATOMIZED USER CONFIG
        home-manager.users.your-user = {
          imports = [
            self.homeModules.dev-cli
            self.homeModules.dev-git
            # Add more homeModules here
          ];
        };
      }
      # ATOMIZED SYSTEM CONFIG
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.dev-cli
      # Add more nixosModules here
    ];
  };
}
```

## Adding Logic

1. **Add a file**: Create `modules/category/feature.nix`.
2. **Export Modules**:
   ```nix
   { ... }: {
     flake.nixosModules.feature = { pkgs, ... }: { ... };
     flake.homeModules.feature = { pkgs, ... }: { ... };
   }
   ```
3. **Use in Host**: Reference `self.nixosModules.feature` or `self.homeModules.feature` in your host configuration.
