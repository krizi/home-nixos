{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hellga-vm-hardware.nix
    ../modules/users/user-kubernetes.nix
    ../modules/nix-management/auto-update.nix
  ];

  networking.hostName = "k8s-master-01";

  # used to build rpi image
  #  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  #  nix.settings.extra-platforms = [ "aarch64-linux" ];
}
