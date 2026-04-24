{ ... }: {
  flake.nixosModules.style-plasma = { pkgs, ... }: {
    # System-level plasma styling dependencies could go here if needed
  };

  flake.homeModules.style-plasma = { pkgs, lib, ... }: {
    home.activation.applyPlasmaAesthetics = lib.hm.dag.entryAfter ["writeBoundary"] ''
      PATH="${pkgs.kdePackages.plasma-workspace}/bin:${pkgs.kdePackages.kgamma}/bin:${pkgs.kdePackages.kconfig}/bin:${pkgs.kdePackages.qttools}/bin:$PATH"

      # Aesthetics
      $DRY_RUN_CMD plasma-apply-lookandfeel -a org.kde.breezedark.desktop || true
      $DRY_RUN_CMD plasma-apply-wallpaperimage ${../assets/wallpaper.png} || true

      # Number of Virtual Desktops
      $DRY_RUN_CMD kwriteconfig6 --file kwinrc --group Desktops --key Number 3

      # Default Font Override (Standardized KDE Font Serialization)
      $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key font "monospace,10,-1,5,50,0,0,0,0,0"
      $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key fixed "monospace,10,-1,5,50,0,0,0,0,0"

      # Default Terminal Override
      $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key TerminalApplication "alacritty"

      # Terminal Hotkey Override
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group "services/org.kde.alacritty.desktop" --key "_launch" "Ctrl+Alt+T\tMeta+Return,none,Alacritty"

      # Vi-Key Desktop Navigation (Switching)
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" "Meta+H,none,Switch One Desktop to the Left"
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Down" "Meta+J,none,Switch One Desktop Down"
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Up" "Meta+K,none,Switch One Desktop Up"
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" "Meta+L,none,Switch One Desktop to the Right"

      # Vi-Key Window Movement (Moving Active Window to another Desktop)
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop to the Left" "Meta+Shift+H,none,Window One Desktop to the Left"
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop Down" "Meta+Shift+J,none,Window One Desktop Down"
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop Up" "Meta+Shift+K,none,Window One Desktop Up"
      $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop to the Right" "Meta+Shift+L,none,Window One Desktop to the Right"

      # Inform the daemon to reload the shortcut registry
      $DRY_RUN_CMD qdbus6 org.kde.kglobalaccel /kglobalaccel reparseConfiguration || true
    '';
  };
}
