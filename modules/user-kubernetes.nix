{ config, pkgs, ... }:

{
  users.users.kubernetes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sudo" ];
    shell = pkgs.bash;
  };
}
