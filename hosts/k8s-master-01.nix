{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hellga-vm-hardware.nix
    ../modules/users/user-kubernetes.nix
    ../modules/k0s.nix
    ../modules/nix-management/auto-update.nix
  ];

  networking.hostName = "k8s-master-01";

  # k0s Controller
  services.k0s = {
    enable = true;
    isLeader = true;
    role = "controller";
    clusterName = "hellga";
    # typischer Datenordner
    dataDir = "/var/lib/k0s";

    spec = {
      network = {
        kubeProxy = {
          disabled = true;
        };
      };
    };

  };

  # used to build rpi image
  #  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  #  nix.settings.extra-platforms = [ "aarch64-linux" ];
}
