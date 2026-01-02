{ config, pkgs, ... }:

{
  imports = [
    ./hardware/raspberry-pi-4-model-b-hardware.nix
    ../modules/users/user-kubernetes.nix
    ../modules/nix-management/auto-update.nix
    ../modules/raspi-sd-image.nix
  ];

  networking.hostName = "k8s-worker-rpi-01";

  environment.etc."k0s/k0stoken".text = builtins.readFile ../tokens/k8s-worker-rpi-01.txt;

  # k0s worker service aktivieren
  services.k0s = {
    enable = true;
    role = "worker";

    clusterName = "hellga";
    dataDir = "/var/lib/k0s";
    tokenFile = "/etc/k0s/k0stoken";

    configText = builtins.readFile ../k0s.cluster.yaml;
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
