{ config, pkgs, ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
  };

  boot.kernelModules = [
    "br_netfilter"
    "overlay"
  ];

  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    k0s
    iproute2
    iptables
    conntrack-tools
    socat
    curl
  ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  systemd.enableUnifiedCgroupHierarchy = true;
}
