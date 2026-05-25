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
              icon = "https://nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@np" ];
            };
            "Startpage" = {
              urls = [{ template = "https://www.startpage.com/sp/search?query={searchTerms}&lui=english&language=english"; }];
            };
            "google".metaData.alias = "@g";
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

          # --- TELEMETRY & DATA COLLECTION ---
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          
          # --- BLOAT REMOVAL ---
          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.ml.voice.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.searches" = false;
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
          /* Zen-like Minimalist UI */

          /* Hide native horizontal tabs for Sidebery */
          #TabsToolbar { visibility: collapse !important; }
          
          /* Hide sidebar header */
          #sidebar-header { display: none; }
          
          /* Sidebar Splitter Cleanliness */
          #sidebar-splitter { border: none !important; width: 1px !important; opacity: 0 !important; }
        '';

        userContent = ''
          /* Upscale Sidebery UI */
          @-moz-document url-prefix("moz-extension://") {
            :root {
              --tabs-font: 15px "${config.stylix.fonts.monospace.name}", monospace !important;
              --tabs-height: 42px !important;
              --tabs-inner-gap: 10px !important;
              --tabs-pinned-height: 48px !important;
              --tabs-pinned-width: 48px !important;
            }
            
            .Tab .title {
              font-size: 15px !important;
              font-weight: 500 !important;
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

            .Tab[data-active="true"] .title {
              font-weight: 700 !important;
            }
          }
        '';
      };
    };
  };
}
