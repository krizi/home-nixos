{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hellga-vm-hardware.nix
    ../modules/users/user-kubernetes.nix
    ../modules/nix-management/auto-update.nix
  ];

  networking.hostName = "k8s-master-01";

  services.k0s = {
    enable = true;
    isLeader = true;
    role = "controller";
    clusterName = "hellga";
    # typischer Datenordner
    dataDir = "/var/lib/k0s";

    spec = {
      api = {
        address = "k8s-master-01";
      };
      network = {
        kubeProxy = {
          disabled = true;
        };
      };
    };
    package = pkgs.k0s;
  };

  # used to build rpi image
  #  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  #  nix.settings.extra-platforms = [ "aarch64-linux" ];
}
