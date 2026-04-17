{
  description = "My NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [ nur.overlays.default ];
    in {
      nixosConfigurations = {

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            ./configuration.nix
            ./hardware_configs/hardware_configuration_laptop.nix

            { networking.hostName = "laptop"; }
          ];
        };

        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            ./configuration.nix
            ./hardware_configs/hardware_configuration_desktop.nix

            { networking.hostName = "desktop"; }
          ];
        };

      };

      homeConfigurations.myprofile = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

        modules = [ ./home.nix ];
      };
    };
}