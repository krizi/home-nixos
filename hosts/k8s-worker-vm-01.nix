{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hellga-vm-hardware.nix
    ../modules/users/user-kubernetes.nix
    ../modules/nix-management/auto-update.nix
  ];

  networking = {
    hostName = "k8s-worker-vm-01";
    firewall = {
      enable = false;
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

  environment.etc."k0s/k0stoken".text = builtins.readFile ../tokens/k0s-token.txt;

  # k0s worker service aktivieren
  services.k0s = {
    enable = true;
    role = "worker";

    clusterName = "hellga";
    dataDir = "/var/lib/k0s";
    tokenFile = "/etc/k0s/k0stoken";

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
    # optional: Labels
    # extraArgs = [
    #   "--labels zone=arm"
    #   "--labels rack=lab"
    # ];
  };

}
