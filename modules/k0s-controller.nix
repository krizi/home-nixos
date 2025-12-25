# modules/k0s-controller.nix
{ config, pkgs, ... }:

let
  k0sConfig = ''
    apiVersion: k0s.k0sproject.io/v1beta1
    kind: Cluster
    metadata:
      name: nixos-cluster
    spec:
      api:
        # TODO: hier IP oder DNS vom Controller eintragen
        externalAddress: "${config.networking.hostName}"
        sans:
          - "${config.networking.hostName}"
      network:
        provider: "kube-router"
        podCIDR: "10.244.0.0/16"
        serviceCIDR: "10.96.0.0/12"
  '';
in {
  # k0s Konfigurationsdatei bereitstellen
  environment.etc."k0s/k0s.yaml".text = k0sConfig;

  systemd.services.k0s-controller = {
    description = "k0s Kubernetes controller (mit Worker)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      # controller + worker auf demselben Node
      ExecStart = "${pkgs.k0s}/bin/k0s controller --enable-worker --config=/etc/k0s/k0s.yaml";
      Restart = "always";
      RestartSec = 5;

      # /var/lib/k0s
      StateDirectory = "k0s";
      # /run/k0s
      RuntimeDirectory = "k0s";
    };
  };
}
