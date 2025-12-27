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
    serviceConfig = {
      Type = "oneshot";
      StandardOutput = "journal";
      StandardError = "journal";

      ExecStart = "/etc/nixos/scripts/nixos-auto-update.sh";
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
