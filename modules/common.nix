{ config, pkgs, ... }:

{
  networking.useDHCP = true;
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "de";
    font = "Lat2-Terminus16";
  };

  networking = {
    firewall = {
      enable = false;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    #    setOptions = [
    #
    #    ];
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
        "z"
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    curl
    wget
    zsh
    kubernetes
  ];

  system.stateVersion = "24.05";
}
