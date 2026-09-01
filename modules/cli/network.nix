{ ... }: {
  flake.nixosModules.cli-network = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Core Diagnostics & Routing
      mtr
      bind # provides dig
      
      # Traffic Analysis & Packet Sniffing
      tcpdump
      termshark
      tshark

      # Security Auditing & Discovery
      nmap
      lsof

      # Performance & Monitoring
      iperf3
      bandwhich
    ];
  };
}
