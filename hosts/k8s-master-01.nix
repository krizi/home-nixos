{ config, pkgs, ... }:

{
  imports = [
    ./hellga-vm-hardware.nix
    ../modules/k0s-common.nix
    ../modules/user-kubernetes.nix
    ../modules/k0s-controller.nix
  ];

  networking.hostName = "k8s-master-01";
}
