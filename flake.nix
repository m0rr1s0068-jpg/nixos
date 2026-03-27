{
  description = "The Flakes of M0rr1s";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/?shallow=1&ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix/release-25.11";
  };

  outputs =
    inputs@{
      self,
      catppuccin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      ...
    }:
    let
      inherit (self) outputs;
      # Helper function to create a nixos system configuration
      # Usage:
      #   Default x86_64:  mkSystem { host = "hostname"; };
      #   Custom system:   mkSystem { host = "hostname"; system = "aarch64-linux"; };
      mkSystem =
        {
          host,
          system ? "x86_64-linux",
        }:
        nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = system; }
            ./hosts/${host}/configuration.nix
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
    in
    {
      nixosConfigurations = {
        iceman = mkSystem { host = "iceman"; };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}