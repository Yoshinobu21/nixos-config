{
  description = "Nix Multi-Machine System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hypr-rdp.url = "github:MuNeNICK/hypr-rdp";
    browser-previews.url = "github:nix-community/browser-previews";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {

      # ========================================================
      # Headless Homelab Server Profile
      # ========================================================
      "nixos-homelab" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-homelab

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoshinobu = import ./home/homelab.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      # ========================================================
      # Primary Bare-Metal Desktop Profile (AMD)
      # ========================================================
      "nixos-yoshi" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-yoshi

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoshinobu = import ./home/desktop.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      # ========================================================
      # Virtual Machine Desktop Profile (VirtualBox / Testing)
      # ========================================================
      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-vm

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoshinobu = import ./home/desktop.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

    };
  };
}
