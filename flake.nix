{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.rogue = nixpkgs.lib.nixosSystem {  
      modules = [
        ./configuration.nix
      ];
    };
  };
}
