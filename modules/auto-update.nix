{ config, pkgs, ... }:

let
  autoUpdateScript = pkgs.writeShellScriptBin "nixos-auto-update" ''
    /etc/nixos/scripts/nixos-auto-update.sh
  '';
in
{
  environment.systemPackages = [
    pkgs.git
    autoUpdateScript
  ];

  systemd.services.nixos-auto-update = {
    description = "Auto-update NixOS from Git with Prometheus metrics";

    path = [
      pkgs.git
      pkgs.nixos-rebuild
      pkgs.coreutils
      pkgs.bash
    ];
    serviceConfig = {
      Type = "oneshot";
      StandardOutput = "journal";
      StandardError = "journal";

      ExecStart = "${pkgs.bash}/bin/bash /etc/nixos/scripts/nixos-auto-update.sh";
      StateDirectory = "nixos-auto-update";
    };
  };

  systemd.timers.nixos-auto-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/30";
      Persistent = true;
    };
  };
}
