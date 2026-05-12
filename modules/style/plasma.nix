{ ... }: {
  flake.nixosModules.style-plasma = { pkgs, ... }: {
    # System-level plasma styling dependencies could go here if needed
  };

  flake.homeModules.style-plasma = { config, pkgs, lib, ... }: 
    let
      # Only apply manual aesthetics if Stylix is NOT enabled
      noStylix = !(config.stylix.enable or false);
    in {
      home.packages = [ pkgs.papirus-icon-theme pkgs.papirus-folders ];
      
      # Silence GTK4 warning only if Stylix isn't handling it
      gtk.gtk4.theme = lib.mkIf noStylix null;

      home.activation.applyPlasmaAesthetics = lib.hm.dag.entryAfter ["writeBoundary"] ''
        PATH="${pkgs.kdePackages.plasma-workspace}/bin:${pkgs.kdePackages.kgamma}/bin:${pkgs.kdePackages.kconfig}/bin:${pkgs.kdePackages.qttools}/bin:${pkgs.papirus-folders}/bin:$PATH"

        # --- AESTHETICS (Base Dark Reset) ---
        # Force Breeze Dark at the config level to prevent white-on-white Dolphin
        $DRY_RUN_CMD plasma-apply-lookandfeel -a org.kde.breezedark.desktop || true
        $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key ColorScheme "BreezeDark"
        
        # Rice Icons: Use Papirus-Dark and color folders Orange to match Ayu
        $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group Icons --key Theme "Papirus-Dark"
        $DRY_RUN_CMD papirus-folders -C orange --theme Papirus-Dark || true

        # --- FONT OVERRIDE (Conditional) ---
        ${lib.optionalString noStylix ''
          # Default Font Override
          $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key font "monospace,10,-1,5,50,0,0,0,0,0"
          $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key fixed "monospace,10,-1,5,50,0,0,0,0,0"
        ''}

        # --- BEHAVIOR & LAYOUT (Always Apply) ---
        $DRY_RUN_CMD plasma-apply-wallpaperimage ${../assets/wallpaper.png} || true
        $DRY_RUN_CMD kwriteconfig6 --file kwinrc --group Desktops --key Number 3
        $DRY_RUN_CMD kwriteconfig6 --file kwinrc --group Desktops --key Rows 1
        $DRY_RUN_CMD kwriteconfig6 --file kwinrc --group Desktops --key Columns 3
        $DRY_RUN_CMD kwriteconfig6 --file kdeglobals --group General --key TerminalApplication "alacritty"

        # Taskbar: Auto-hide (visibilityMode 1)
        $DRY_RUN_CMD kwriteconfig6 --file plasmashellrc --group "Panels" --group "Panel 1" --key "visibilityMode" 1

        # Shortcuts & Vi-Keys
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group "services/Alacritty.desktop" --key "_launch" "Ctrl+Alt+T${"\t"}Meta+Return,none,Alacritty"
        
        # Spectacle (PrintScreen) - Support both legacy and Plasma 6 names
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group org.kde.spectacle.desktop --key "RectangularRegionScreenShot" "Meta+Shift+S,none,Capture Rectangular Region"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group org.kde.spectacle.desktop --key "_launch" "Print,none,Launch Spectacle"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group spectacle --key "RectangularRegionScreenShot" "Meta+Shift+S,none,Capture Rectangular Region"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group spectacle --key "_launch" "Print,none,Launch Spectacle"

        # Switch Desktops
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" "Meta+H,none,Switch One Desktop to the Left"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Down" "Meta+J,none,Switch One Desktop Down"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Up" "Meta+K,none,Switch One Desktop Up"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" "Meta+L,none,Switch One Desktop to the Right"

        # Move Windows
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop to the Left" "Meta+Shift+H,none,Window One Desktop to the Left"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop Down" "Meta+Shift+J,none,Window One Desktop Down"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop Up" "Meta+Shift+K,none,Window One Desktop Up"
        $DRY_RUN_CMD kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window One Desktop to the Right" "Meta+Shift+L,none,Window One Desktop to the Right"

        # Reload
        $DRY_RUN_CMD qdbus6 org.kde.kglobalaccel /kglobalaccel reparseConfiguration || true
      '';
    };
}
