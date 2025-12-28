{ config, pkgs, ... }:

let
  autoUpdateCli = pkgs.writeShellScriptBin "auto-update" ''
    #!/usr/bin/env bash
    set -euo pipefail
    sudo systemctl start nixos-auto-update.service
  '';
in
{
  environment.systemPackages = [
    autoUpdateCli
  ];

  systemd.services.nixos-auto-update = {
    description = "Auto-update NixOS from Git";

    path = [
      pkgs.coreutils
      pkgs.git
      pkgs.nixos-rebuild
      pkgs.bash
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /etc/nixos/modules/nix-management/scripts/nixos-auto-update.sh";

      StateDirectory = "nixos-auto-update";
      StandardOutput = "journal";
      StandardError = "journal";
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
