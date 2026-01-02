{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hellga-vm-hardware.nix
    ../modules/users/user-kubernetes.nix
    ../modules/nix-management/auto-update.nix
  ];

  networking = {
    hostName = "k8s-worker-vm-01";
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

  environment.systemPackages = [
    pkgs.k0s
  ];
}
