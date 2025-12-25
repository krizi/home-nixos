{ config, pkgs, ... }:

{
    users.users.kubernetes = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };

    fileSystems."/" = {
        device = "/dev/vda";
        fsType = "ext4";
    };
}
