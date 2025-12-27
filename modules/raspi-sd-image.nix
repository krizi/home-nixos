{
  config,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
}
