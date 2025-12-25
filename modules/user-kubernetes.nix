{ config, pkgs, ... }:

{
    users.users.kubernetes = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
            openssh.authorizedKeys.keys = [
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFky8y1fjgWSXlAm78e4sAyeS/kX1BJ2ykS5qX4arbAGM5ICvID564HvGVtB9hb7DXnKBNgbjYfkOYJkOWf5cx4Rrhhd9MoBzOdN+4pG2wGg8Ghu5cY1qIS8NCjA7U6tYU21hB250J7kD/OUhm2ZbIopXw7+MFhxpX5CtXBvfQHwVZhoD9/+AtA5f01wxekQyIgB2kSUBtp3RgQ1qJppMePd93wRIpnmpMTRz4LYHcR278N/MoJ1TRsQPFTfJAk46+xA3wOVd464ai4PHqNrwHNET5DwxtL7b0G8OfkuA9YoYlZds435Oq3Ob9icdbCkROzL/AtQVoA0hAskRNnDGAd8DH0jWJqHbLbVK2m+b88mNT6fSEh4hoBikB5lPtwbUysYpnPTDK5VWoPbgcK85G1szAFOYVBBoPQbRUYLADG54n27HhuY/T4/bmRTx21KggLr/2l/ehqezd6O5XRf7R554bPC2AbLuN/x1WTz7SP/M/VI9Vlq3x2pymO241C2hUrFahWupfsd2eGZiwf8x4Eb4En7RDO2JTcT6iXQ9Ob4ZjLSUYbpRibUcWMHqK+5wc3ND4GUlSQlgR8IdbbGvyKkgU9uRwDOtpwrXAeoqcu93kU5ML+PjeHEf9MD5B5dVVyqHAj4S1ZgjuWKzSjHRpmwBdCvdcVL5tVkbdnOPidw== kluster auth"
            ];
    };

  home-manager.users.kubernetes = { pkgs, ... }: {
    home.username = "kubernetes";
    home.homeDirectory = "/home/kubernetes";

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins = [
          "git"
          "docker"
          "z"
        ];
      };
    };

    programs.git.enable = true;

    home.stateVersion = "24.05";
  };

boot.initrd.supportedFilesystems = [ "ext4" ];
boot.supportedFilesystems = [ "ext4" ];
  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/vda1";
    fsType = "vfat";
  };
}
