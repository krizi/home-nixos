{ config, pkgs, ... }:

{
  systemd.services.nixos-auto-update = {
    description = "Auto-update NixOS from Git with Prometheus metrics";

    path = [
      pkgs.coreutils
      pkgs.git
      pkgs.nixos-rebuild
      pkgs.bash
    ];

    serviceConfig = {
      Type = "oneshot";

      ExecStart = "${pkgs.bash}/bin/bash /etc/nixos/scripts/nixos-auto-update.sh";

      StateDirectory = "nixos-auto-update";

      StandardOutput = "journal";
      StandardError = "journal";
    };

    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.nixos-auto-update = {
    description = "Timer for auto-updating NixOS from Git";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*:0/30"; # alle 30 Minuten
      Persistent = true; # nachholen, falls System offline war
    };
  };
}
