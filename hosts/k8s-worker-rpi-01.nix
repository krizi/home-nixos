{ config, pkgs, ... }:

{
  imports = [
    ./hardware/raspberry-pi-4-model-b-hardware.nix
    ../modules/k3s/k3s-common.nix
    ../modules/users/user-kubernetes.nix
    ../modules/k3s/k3s-agent.nix
    ../modules/nix-management/auto-update.nix
    ../modules/raspi-sd-image.nix
  ];

  networking.hostName = "k8s-worker-rpi-01";

  k3s.nodeLabels = {
    "topology.kubernetes.io/region" = "ch-central";
    "topology.kubernetes.io/zone" = "hellga";
  };
}
