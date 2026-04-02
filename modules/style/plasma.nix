{ ... }: {
  # Removed `lib` from the top-level NixOS module parameters
  flake.nixosModules.style-plasma = { pkgs, ... }: {

    # Structural Shift: Convert the user block into a function to capture the HM extended lib
    home-manager.users.crow = { lib, ... }: {

      home.activation.applyPlasmaAesthetics = lib.hm.dag.entryAfter ["writeBoundary"] ''
      PATH="${pkgs.kdePackages.plasma-workspace}/bin:${pkgs.kdePackages.kgamma}/bin:${pkgs.kdePackages.kconfig}/bin:${pkgs.kdePackages.qttools}/bin:$PATH"


        # Aesthetics
        $DRY_RUN_CMD plasma-apply-lookandfeel -a org.kde.breezedark.desktop || true
        $DRY_RUN_CMD plasma-apply-wallpaperimage ${../assets/wallpaper.png} || true

        # Default Terminal Override
        $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key TerminalApplication "alacritty"

        # Terminal Hotkey Override
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group "services/org.kde.alacritty.desktop" --key "_launch" "Ctrl+Alt+T\tMeta+Return,none,Alacritty"

        # Vi-Key Workspace Navigation
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" "Meta+H,Meta+Ctrl+Left,Switch One Desktop to the Left"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Down" "Meta+J,Meta+Ctrl+Down,Switch One Desktop Down"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Up" "Meta+K,Meta+Ctrl+Up,Switch One Desktop Up"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" "Meta+L,Meta+Ctrl+Right,Switch One Desktop to the Right"

        # Inform the daemon to reload the shortcut registry
        $DRY_RUN_CMD qdbus6 org.kde.kglobalaccel /kglobalaccel reparseConfiguration || true
      '';
    };
  };
}
