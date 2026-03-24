# Host identity + disk layout + bootloader + machine quirks (not software "role").
{ ... }:
{
  networking.hostName = "thinkpad";
  imports = [
    ./hardware.nix
    ./boot.nix
    ./traits.nix
  ];
}
