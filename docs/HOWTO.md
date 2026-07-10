# Cocoon OS - How-To Guide

This document provides quick reference steps for everyday tasks when managing the Cocoon OS environment.

## How to Edit the System Manual
To update the manual displayed when you run `sys-manual`:
1. Open [`docs/manual.md`](file:///home/crow/Infrastructure/NixOS/docs/manual.md).
2. Make your edits in standard Markdown.
3. Rebuild your system using your `nr` alias.

## How to Add or Edit Aliases
Your personal aliases are decoupled from the main system orchestrator for safety.
1. Open [`modules/hosts/thinkpad/aliases.nix`](file:///home/crow/Infrastructure/NixOS/modules/hosts/thinkpad/aliases.nix).
2. Add your alias to the `cocoon.aliases` dictionary.
3. Rebuild your system using your `nr` alias.

## How to Add a New CLI Tool
Because of the **Dendritic Pattern**, adding a new tool is as simple as creating a file.
1. Create a new file in [`modules/dev/tools/`](file:///home/crow/Infrastructure/NixOS/modules/dev/tools/), for example `mytool.nix`.
2. Define your tool using standard NixOS or Home Manager attributes wrapped in `flake-parts`:
   ```nix
   { ... }: {
     flake.homeModules.dev-tools-mytool = { pkgs, ... }: {
       home.packages = [ pkgs.mytool ];
     };
   }
   ```
3. Open your host orchestrator at [`modules/hosts/thinkpad/host.nix`](file:///home/crow/Infrastructure/NixOS/modules/hosts/thinkpad/host.nix).
4. Add `self.homeModules.dev-tools-mytool` to the `modules = [ ... ]` list.
5. Rebuild your system (`nr`).
