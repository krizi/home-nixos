{ config, pkgs, ... }:

{
  imports = [
    ./k8s-master-01-hardware.nix
  ];

  networking.hostName = "k8s-master-01";
}
