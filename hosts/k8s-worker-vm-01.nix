{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
  ];

  networking.hostName = "k8s-worker-vm-01";
}
