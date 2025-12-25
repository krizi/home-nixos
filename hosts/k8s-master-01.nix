{ config, pkgs, ... }:

{
  # Diese Datei importierst du später aus dem Live-System:
  #   nixos-generate-config --root /mnt
  # und verschiebst sie dann nach z. B.:
  #   /etc/nixos/hosts/k8s-master-01-hardware.nix
  imports = [
    ../hardware-configuration.nix
  ];

  networking.hostName = "k8s-master-01";

  # Hier kannst du master-spezifische Dinge ergänzen (z.B. k8s-control-plane-services)
}
