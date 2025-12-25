{ config, pkgs, ... }:

{
    users.users.kubernetes = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };


  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/vda1";
    fsType = "vfat";
  };
}
