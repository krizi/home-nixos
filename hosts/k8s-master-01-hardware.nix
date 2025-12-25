{ config, lib, pkgs, modulesPath, ...}:
{
    imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk"];
    boot.initrd.kernelModuels = [];
    boot.kernelMdoules = ["kvm-amd"];
    boot.extraModulePackages = [];

    swapDevices = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}