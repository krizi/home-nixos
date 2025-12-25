{ config, pkgs, ... }:

{
  ########################
  # User "kubernetes"
  ########################

  users.users.kubernetes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      # 👉 HIER deinen echten Public Key einfügen
      "ssh-ed25519 AAAA...DEIN_SSH_PUBLIC_KEY_HIER... user@host"
    ];
  };

  ########################
  # Home-Manager für "kubernetes"
  ########################

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
}
