{ config, pkgs, ... }:

{
  ########################
  # Basis
  ########################

  networking.useDHCP = true;
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "de";
    font = "Lat2-Terminus16";
  };

  ########################
  # SSH + Firewall
  ########################

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  ########################
  # sudo
  ########################

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  ########################
  # Packages / Tools
  ########################

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    curl
    wget
    zsh
  ];

  ########################
  # Bootloader (für „normale“ VMs)
  ########################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";
}
