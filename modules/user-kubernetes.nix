{ config, pkgs, ... }:

{
    users.users.kubernetes = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };

boot.initrd.supportedFilesystems = [ "ext4" ];
boot.supportedFilesystems = [ "ext4" ];
  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/vda1";
    fsType = "vfat";
  };
}
