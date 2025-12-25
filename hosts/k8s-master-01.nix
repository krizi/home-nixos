{ config, pkgs, ... }:

{
  imports = [
    ./hellga-vm-hardware.nix
    ../modules/k3s-common.nix
    ../modules/user-kubernetes.nix
    ../modules/k3s-server.nix
  ];

  networking.hostName = "k8s-master-01";

  # HA-Init
  environment.variables.K3S_CLUSTER_INIT = "true";
}
