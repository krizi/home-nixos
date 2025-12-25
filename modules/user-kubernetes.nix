{ config, pkgs, ... }:

{
  users.users.kubernetes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
