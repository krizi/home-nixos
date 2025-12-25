{ config, pkgs, ... }:

{
  imports = [
    ./hellga-vm-hardware.nix
  ];

  networking.hostName = "k8s-master-01";
}
