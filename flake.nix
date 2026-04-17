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
            ./hosts/laptop.nix
          ];
        };

        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            ./configuration.nix
            ./hosts/desktop.nix
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