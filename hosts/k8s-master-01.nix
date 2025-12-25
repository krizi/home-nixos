{ config, pkgs, ... }:

{
  imports = [
    ./hellga-vm-hardware.nix
    ../modules/k3s-common.nix
    ../modules/user-kubernetes.nix
    ../modules/k3s-server.nix
  ];

  networking.hostName = "k8s-master-01";

  k3s.nodeLabels = {
    "topology.kubernetes.io/region" = "ch-central";
    "topology.kubernetes.io/zone" = "hellga";
  };
}
