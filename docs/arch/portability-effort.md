# Portability Effort: Breaking the NixOS Lock

This document tracks the progress, discoveries, and future plans for making the Dendritic configuration architecture truly platform-agnostic (NixOS, Ubuntu/Debian via Standalone Home Manager, macOS, etc.).

## Status: Proven (Git Module Refactored)

The first step of the refactor has been completed on the `refactor-platform-agnostic` branch. The `git` module (`modules/dev/git.nix`) was successfully decoupled from NixOS-specific options.

### Key Changes
- **Module Splitting:** Removed the `flake.nixosModules.dev-git` wrapper which was using `environment.systemPackages`.
- **Logic Consolidation:** All packages (`git`, `git-lfs`, `gh`) and configurations were moved into `flake.homeModules.dev-git` under `home.packages` and `programs.git`.
- **Unified Host Logic:** Existing NixOS hosts (like `thinkpad`) now naturally inherit these tools via their Home Manager integration, while non-NixOS hosts can import the same module directly.

## Discoveries & Learnings

### 1. Standalone Home Manager Portability
Verification tests using **Ubuntu (Noble)** and **NixOS (nixos/nix container)** confirmed that modules defined as `homeModules` are 100% portable. The configuration applied identical git settings and installed the same binary versions across different Linux distributions.

### 2. Profile Conflicts in Standalone Nix
When running Home Manager on non-NixOS systems (or minimal Nix installations), we discovered that pre-installed profile packages can cause activation failures.
- **Example:** `git-minimal` or `man-db` being present in the user's default `nix-env` profile.
- **Solution:** For clean transitions, it may be necessary to purge existing profile packages (`nix-env -e "*"`) to allow Home Manager to take full control of the user environment path.

### 3. The "Atomized" Pattern Works
The architecture's ability to co-locate logic in `modules/` remains its greatest strength. By simply changing which attribute we export (`homeModules` vs `nixosModules`), we can toggle portability without moving files or losing the "dendritic" discovery.

## Future Plans (The Roadmap)

### Phase 1: Modular Decoupling (In Progress)
- [ ] **Audit CLI Tools:** Move `bat`, `eza`, `fd`, `ripgrep`, etc., from `core.nix` or system-level modules into portable `homeModules`.
- [ ] **Shell Refactor:** Ensure `nushell` and `starship` modules are fully portable.
- [ ] **Editor Portability:** Verify `helix` and `neovim` logic is platform-independent.

### Phase 2: Structural Improvements
- [ ] **Username Parameterization:** Move away from hardcoded user `crow`. Implement a custom option (e.g., `cocoon.user`) that modules can reference.
- [ ] **Automated Home Manager Outputs:** Update the flake collector to automatically generate `homeConfigurations` for registered portable hosts.

### Phase 3: Cross-Platform Expansion
- [ ] **Nix-Darwin Integration:** Introduce `darwinModules` support to the dendritic tree for macOS support.
- [ ] **Portable Host Template:** Create a host template in `modules/hosts/` specifically for non-NixOS machines.
