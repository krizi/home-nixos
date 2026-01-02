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
    dataDir = "/var/lib/k0s";
    configText = builtins.readFile ../k0s.cluster.yaml;

    package = pkgs.k0s;
  };

  environment.systemPackages = [
    pkgs.k0s
  ];

  # used to build rpi image
  #  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  #  nix.settings.extra-platforms = [ "aarch64-linux" ];
}
