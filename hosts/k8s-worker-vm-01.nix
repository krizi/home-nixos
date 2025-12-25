{ config, pkgs, ... }:

{
  imports = [
    ./k8s-worker-vm-01-hardware.nix
  ];

  networking.hostName = "k8s-worker-vm-01";

  # Worker-spezifische Einstellungen kommen hierhin (z.B. nur kubelet, keine control-plane-Komponenten)
}
