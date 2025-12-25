{ config, pkgs, ... }:

{
  imports = [
    ./hellga-vm-hardware.nix
    ../modules/k3s-common.nix
    ../modules/user-kubernetes.nix
    ../modules/k3s-agent.nix
  ];

  networking.hostName = "k8s-worker-vm-01";
}
