{ config, pkgs, ... }:

{
  systemd.services.k3s-server = {
    description = "k3s server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "notify";

      ExecStart = ''
        ${pkgs.k3s}/bin/k3s server \
          --disable traefik \
          --node-name ${config.networking.hostName} \
          ${config.environment.variables.K3S_NODE_LABEL_FLAGS} \
          --write-kubeconfig-mode value 644
      '';

      Restart = "always";
      RestartSec = 5;

      StateDirectory = "rancher/k3s";
      RuntimeDirectory = "k3s";
    };
  };
}
