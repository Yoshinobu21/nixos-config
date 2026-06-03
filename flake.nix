{
  description = "Nix Hyprland Yoshi";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # 1. Add the Home Manager input
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hypr-rdp.url = "github:MuNeNICK/hypr-rdp";
    browser-previews.url = "github:nix-community/browser-previews";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  # 2. Add home-manager to your outputs arguments
  outputs = inputs @ { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      
      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration-vm.nix 
          { networking.hostName = "nixos-vm"; }
          
          # 3. Inject Home Manager into the VM module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoshinobu = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      "nixos-yoshi" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix 
          ./amd-hardware.nix           
          { networking.hostName = "nixos-yoshi"; }
          
          # 4. Inject Home Manager into the Desktop module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoshinobu = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
      
    };
  };
}
