{ ... }: {
  flake.nixosModules.dev-local-ai = { pkgs, ... }: {

    # System-level Ollama Daemon
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cpu;
      environmentVariables = {
        OLLAMA_KEEP_ALIVE = "3m";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";

        # VISUALIZATION INJECTION: Force verbose logging to systemd
        OLLAMA_DEBUG = "1";

        # STRUCTURAL LIMITER: Hard-cap the context window to prevent CPU lockup.
        # 2048 tokens is the optimal ceiling for your processor.
        OLLAMA_NUM_CTX = "2048";
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
