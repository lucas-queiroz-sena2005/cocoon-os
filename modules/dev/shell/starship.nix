{ ... }: {
  flake.homeModules.dev-shell-starship = { ... }: {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      
      settings = {
        # DevOps/Matrix aesthetic
        format = "$all";
        kubernetes.disabled = false; # Enable k8s context display
        docker_context.disabled = false;
        
        # Powerline/Vi-mode visual indicators
        character = {
          success_symbol = "[➜](bold blue)";
          error_symbol = "[➜](bold red)";
          vimcmd_symbol = "[⊚](bold magenta)";
        };

        # High-signal DevOps indicators
        gcloud.disabled = true; # Clean noise
        aws.disabled = true;
      };
    };
  };
}
