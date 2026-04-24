{ ... }: {
  flake.homeModules.dev-shell-starship = { ... }: {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      
      settings = {
        palette = "rose_pine";
        palettes.rose_pine = {
          rose = "#ebbcba";
          pine = "#31748f";
          foam = "#9ccfd8";
          iris = "#c4a7e7";
          highlight_low = "#21202e";
          highlight_med = "#403d52";
          highlight_high = "#524f67";
          muted = "#1f1d2e";
          subtle = "#908caa";
          surface = "#1f1d2e";
          overlay = "#26233a";
          text = "#e0def4";
          love = "#eb6f92";
          gold = "#f6c177";
          base = "#191724";
        };
        # DevOps/Matrix aesthetic
        format = "$all";
        kubernetes.disabled = false; # Enable k8s context display
        docker_context.disabled = false;
        
        # Powerline/Vi-mode visual indicators
        character = {
          success_symbol = "[➜](bold pine)";
          error_symbol = "[➜](bold love)";
          vimcmd_symbol = "[⊚](bold iris)";
        };

        # High-signal DevOps indicators
        gcloud.disabled = true; # Clean noise
        aws.disabled = true;
      };
    };
  };
}
