{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hellga-vm-hardware.nix
    ../modules/users/user-kubernetes.nix
    ../modules/nix-management/auto-update.nix
  ];

  networking = {
    hostName = "k8s-master-01";
    firewall = {
      enable = false;
      allowedUDPPortRanges = [
        {
          from = 8472;
          to = 8472;
        }
        {
          from = 53;
          to = 53;
        }
        {
          from = 30000;
          to = 32767;
        }
        {
          from = 51871;
          to = 51890;
        }
      ];
      allowedTCPPorts = [
        22
        2380
        6443
        4789
        10250
        9443
        8132
        8133
        # cilium
        2379
        2380
        8472
        4240
        4244
        4245
        4250
        4251
        6060
        6061
        6062
        9878
        9879
        9890
        9891
        9893
        9901
        9962
        9963
        9964
        51871
      ];
    };
  };
  services.k0s = {
    enable = true;
    isLeader = true;
    role = "controller";
    clusterName = "hellga";
    dataDir = "/var/lib/k0s";

    spec = {
      api = {
        address = "192.168.4.175";
        externalAddress = "k8s-master-01";
        sans = [
          "192.168.4.175"
          "k8s-master-01"
        ];
      };
      network = {
        kubeProxy = {
          disabled = true;
        };
      };
    };
    package = pkgs.k0s;
  };

  environment.systemPackages = [
    pkgs.k0s
  ];

  # used to build rpi image
  #  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  #  nix.settings.extra-platforms = [ "aarch64-linux" ];
}
