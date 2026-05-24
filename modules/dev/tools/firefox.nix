{ inputs, ... }: {
  flake.homeModules.dev-tools-firefox = { pkgs, config, lib, ... }: {
    stylix.targets.firefox.profileNames = [ "default" ];

    programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
        extensions.packages = with inputs.firefox-addons.packages."${pkgs.system}"; [
          sidebery
          multi-account-containers
          ublock-origin
          bitwarden
        ];

        containers = {
          Personal = { id = 1; color = "blue"; icon = "fingerprint"; };
          Work = { id = 2; color = "orange"; icon = "briefcase"; };
          Private = { id = 3; color = "purple"; icon = "fence"; };
          Dev = { id = 4; color = "turquoise"; icon = "circle"; };
        };

        search = {
          default = "Startpage";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "25.11"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              iconUpdateURL = "https://nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@np" ];
            };
            "Startpage" = {
              urls = [{ template = "https://www.startpage.com/sp/search?query={searchTerms}&lui=english&language=english"; }];
            };
            "Google".metaData.alias = "@g";
          };
        };

        settings = {
          # --- PERSISTENCE ---
          "privacy.sanitize.sanitizeOnShutdown" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.sessions" = false;
          "network.cookie.lifetimePolicy" = 0; 
          
          # --- PRIVACY & FINGERPRINTING ---
          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.letterboxing" = true;
          "privacy.window.maxInnerWidth" = 1600;
          "privacy.window.maxInnerHeight" = 900;
          "media.peerconnection.enabled" = false;
          "network.dns.disableIPv6" = true;
          "privacy.firstparty.isolate" = true;
          "network.cookie.cookieBehavior" = 5;
          
          # --- BLOAT REMOVAL ---
          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.ml.voice.enabled" = false;
          "browser.topsites.controversial.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          
          # --- UI & MISC ---
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.aboutConfig.showWarning" = false;
          "extensions.pocket.enabled" = false;
          "browser.tabs.loadInBackground" = true;
        };

        userChrome = ''
          /* Zen-like Minimalist UI with Ayu Evolve Palette */
          :root {
            --ayu-bg: #020202;
            --ayu-fg: #dedede;
            --ayu-accent: #ff8732; /* Ayu Orange */
            --ayu-border: #1c1c1c;
          }

          /* Hide native horizontal tabs for Sidebery */
          #TabsToolbar { visibility: collapse !important; }
          
          /* Hide sidebar header */
          #sidebar-header { display: none; }
          
          /* Sidebar Splitter Cleanliness */
          #sidebar-splitter { border: none !important; width: 1px !important; opacity: 0 !important; }

          /* Theming the URL Bar (Always Visible) */
          #nav-bar {
            background: var(--ayu-bg) !important;
            border-bottom: 1px solid var(--ayu-border) !important;
            box-shadow: none !important;
          }

          /* Browser Content Area styling */
          #webext-panels-stack,
          #appcontent {
            border-radius: 12px !important;
            border: 1px solid var(--ayu-border) !important;
            overflow: hidden !important;
            margin: 8px !important;
            box-shadow: 0 8px 24px rgba(0,0,0,0.5) !important;
          }

          /* Active focus border - subtle orange highlight */
          #appcontent:focus-within {
            border-color: var(--ayu-accent) !important;
          }
        '';

        userContent = ''
          /* Upscale and Theme Sidebery UI */
          @-moz-document url-prefix("moz-extension://") {
            :root {
              --tabs-font: 15px "${config.stylix.fonts.monospace.name}", monospace !important;
              --tabs-height: 42px !important;
              --tabs-inner-gap: 10px !important;
              --tabs-pinned-height: 48px !important;
              --tabs-pinned-width: 48px !important;
              
              /* Ayu Evolve Colors for Sidebery */
              --bg: #020202 !important;
              --fg: #dedede !important;
              --act-bg: #ff8732 !important;
              --act-fg: #020202 !important;
            }
            
            .Tab .title {
              font-size: 15px !important;
              font-weight: 500 !important;
              color: var(--fg) !important;
            }

            .Tab .fav {
              width: 20px !important;
              height: 20px !important;
            }

            /* Make Pinned Tabs more prominent */
            .PinnedTab {
              width: var(--tabs-pinned-width) !important;
              height: var(--tabs-pinned-height) !important;
            }

            .PinnedTab .fav {
              width: 24px !important;
              height: 24px !important;
            }

            .Tab:hover {
              background: #111111 !important;
            }

            .Tab[data-active="true"] {
              background: var(--act-bg) !important;
            }

            .Tab[data-active="true"] .title {
              color: var(--act-fg) !important;
              font-weight: 700 !important;
            }
          }
        '';
      };
    };
  };
}
