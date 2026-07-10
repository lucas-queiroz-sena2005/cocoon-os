{ ... }: {
  cocoon.aliases = {
    # Modern tool overrides
    cat = "bat --style=plain --paging=never";
    opt = "manix";
    tree = "eza --tree --icons";
    ls = "eza --icons";
    cd = "z";

    # System and utilities
    nr = "sudo nixos-rebuild switch --flake .#thinkpad";
    yt = "ytfzf -T chafa";
    agy = "antigravity-cli";
    sys-help = "sys-manual";
  };
}
