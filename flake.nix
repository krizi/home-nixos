{
  description = "NixOS K8s lab: master + worker VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      # Für VMs auf Apple Silicon: "aarch64-linux"
      # Für normale x86_64-Kisten: "x86_64-linux"
      system = "aarch64-linux";
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        k8s-master-01 = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/k8s-master-01.nix
            ./modules/common.nix
            ./modules/k3s-node-labels.nix
            ./modules/user-kubernetes.nix
            home-manager.nixosModules.home-manager
          ];
        };

        k8s-worker-vm-01 = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/k8s-worker-vm-01.nix
            ./modules/common.nix
            ./modules/k3s-node-labels.nix
            ./modules/user-kubernetes.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
