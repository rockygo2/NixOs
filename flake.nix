{
  description = "My Home Manager configuration";

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
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      overlays = [ nur.overlays.default ];
      pkgs = import nixpkgs { 
        inherit system; 
        inherit overlays; 
        config = { allowUnfree = true; };
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };

      homeConfigurations = {
        myprofile = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix
          ];
        };
      };

    };

} 
