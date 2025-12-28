{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hellga-vm-hardware.nix
    ../modules/k3s/k3s-common.nix
    ../modules/users/user-kubernetes.nix
    ../modules/k3s/k3s-server.nix
    ../modules/nix-management/auto-update.nix
  ];

  networking.hostName = "k8s-master-01";

  k3s.nodeLabels = {
    "topology.kubernetes.io/region" = "ch-central";
    "topology.kubernetes.io/zone" = "hellga";
  };

  # used to build rpi image
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];
}
