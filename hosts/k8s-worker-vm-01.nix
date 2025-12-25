{ config, pkgs, ... }:

{
  imports = [
    ./hellga-vm-hardware.nix
  ];

  networking.hostName = "k8s-worker-vm-01";
}
