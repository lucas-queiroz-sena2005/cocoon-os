{ ... }: {
  flake.nixosModules.dev-local-ai = { pkgs, ... }: {

    # System-level Ollama Daemon
    services.ollama = {
      enable = true;
      # STRUCTURAL FIX: Bind strictly to the CPU derivation.
      package = pkgs.ollama-cpu;
      environmentVariables = {
        OLLAMA_KEEP_ALIVE = "3m";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };

    # User-space AI tools
    home-manager.users.crow = { ... }: {
      home.packages = with pkgs; [
        oterm
        aider-chat
      ];
    };

  };
}
