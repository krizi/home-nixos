# modules/k0s-worker.nix
{ config, pkgs, ... }:

{
  systemd.services.k0s-worker = {
    description = "k0s Kubernetes worker";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    # nur starten, wenn Join-Token vorhanden ist
    unitConfig.ConditionPathExists = "/var/lib/k0s/join-token";

    serviceConfig = {
      ExecStart = "${pkgs.k0s}/bin/k0s worker --token-file=/var/lib/k0s/join-token";
      Restart = "always";
      RestartSec = 5;

      StateDirectory = "k0s";
      RuntimeDirectory = "k0s";
    };
  };
}
