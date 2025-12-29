{
  description = "NixOS K8s lab: master + worker VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    k0s-nix = {
      url = "github:johbo/k0s-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      k0s-nix,
      ...
    }:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        k8s-master-01 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/k8s-master-01.nix
            ./modules/common.nix
            ./modules/users/user-kubernetes.nix
            home-manager.nixosModules.home-manager
            (
              { ... }:
              {
                nixpkgs.overlays = [ k0s-nix.overlays.default ];
              }
            )
            k0s-nix.nixosModules.default
          ];
        };

        k8s-worker-vm-01 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/k8s-worker-vm-01.nix
            ./modules/common.nix
            ./modules/k3s/k3s-node-labels.nix
            ./modules/users/user-kubernetes.nix
            home-manager.nixosModules.home-manager
          ];
        };

        k8s-worker-rpi-01 = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/k8s-worker-rpi-01.nix
            ./modules/common.nix
            ./modules/k3s/k3s-node-labels.nix
            ./modules/users/user-kubernetes.nix
            ./modules/raspi-sd-image.nix
            home-manager.nixosModules.home-manager
          ];
        };

      };
    };
}
