{ config, pkgs, ... }:

{
  home = {
    username = "kubernetes";
    homeDirectory = "/home/kubernetes";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
}
