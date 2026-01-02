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
      enable = true;
      networking.firewall.allowedTCPPortRanges = [
        {
          from = 30000;
          to = 32767;
        }
      ];
      networking.firewall.allowedUDPPortRanges = [
        {
          from = 30000;
          to = 32767;
        }
      ];
    };
  };

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "agnoster";
    plugins = [
      "git"
      "sudo"
      "colored-man-pages"
      "z"
    ];
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
