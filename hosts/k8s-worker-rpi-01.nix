{ config, pkgs, ... }:

{
  imports = [
    ./hardware/raspberry-pi-4-model-b-hardware.nix
    ../modules/k3s-common.nix
    ../modules/user-kubernetes.nix
    ../modules/k3s-agent.nix
  ];

  networking.hostName = "k8s-worker-rpi-01";

  k3s.nodeLabels = {
    "topology.kubernetes.io/region" = "ch-central";
    "topology.kubernetes.io/zone" = "hellga";
  };
}
