{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
    "xhci_pci"
  ];
  boot.kernelParams = [
    "console=ttyAMA0,115200"
    "console=tty1"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
  };

  boot.kernelModules = [
    "br_netfilter"
    "overlay"
  ];

  swapDevices = [ ];

  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "ext4"
  ];

  # Übliche Raspberry-Treiber
  hardware.deviceTree.enable = true;

  networking.useDHCP = lib.mkDefault true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
