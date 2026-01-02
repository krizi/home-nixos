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

      # Eingehende TCP-Ports
      allowedTCPPorts = [
        22 # SSH
        6443 # Kubernetes API-Server (k0s Controller)
        9443 # Konnectivity / k0s control-plane (Logs/Exec/Tunnel)
        10250 # kubelet API
        8132 # k0s intern / supervisory (je nach Setup)
        4240 # Cilium / Hubble (Basis)
        4244 # Hubble (optional)
        4245 # Hubble (optional)
        10248 # kublet
        9234 # cilium operator
        9891 # cilium operator
        42973 # containerd
        9890 # cilium agent
        9878 # cilium envoy
        9964 # cilium envoy
        38455 # cilium agent
        20244 # kube router
        9963 # cilium operator
      ];

      # Eingehende UDP-Ports
      allowedUDPPorts = [
        8472 # Cilium VXLAN Overlay
      ];

      allowedTCPPortRanges = [
        {
          from = 30000;
          to = 32767;
        }
      ];
      allowedUDPPortRanges = [
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
