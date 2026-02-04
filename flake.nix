{
  description = "NixOS-WSL Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
    
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, doomemacs, nix-doom-emacs-unstraightened, ... }@inputs: {
    nixosConfigurations = {
      # The hostname for this configuration is "nixos"
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # BEST PRACTICE: Pass'inputs' into the configuration modules.
        # This allows configuration.nix to access'inputs.nixos-wsl'.
        specialArgs = { inherit inputs; };

        modules = [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.simon = import ./home.nix;
          }
          ./configuration.nix
        ];
      };
    };
  };
}
