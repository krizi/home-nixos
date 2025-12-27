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
