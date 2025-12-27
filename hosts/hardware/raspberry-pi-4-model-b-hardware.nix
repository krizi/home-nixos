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

  boot.initrd.supportedFilesystems = [ "ext4" ];
  boot.supportedFilesystems = [ "ext4" ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/sda2";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Übliche Raspberry-Treiber
  hardware.deviceTree.enable = true;

  networking.useDHCP = lib.mkDefault true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.firmware = [
    pkgs.brcm-firmware
  ];
}
