{ config, pkgs, ... }:

{
  environment.variables.K3S_URL = "https://k8s-master-01:6443";
  environment.variables.K3S_TOKEN_FILE = "/var/lib/rancher/k3s/agent/token";

  systemd.services.k3s-agent = {
    description = "k3s agent";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    unitConfig.ConditionPathExists = "/var/lib/rancher/k3s/agent/token";

    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.k3s}/bin/k3s agent";
      Restart = "always";
      RestartSec = 5;

      StateDirectory = "rancher/k3s/agent";
      RuntimeDirectory = "k3s";
    };
  };
}
