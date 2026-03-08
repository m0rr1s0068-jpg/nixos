{
  description = "General Purpose Configuration for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    agenix.url = "github:ryantm/agenix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/dustinlyons/nix-secrets.git";
      flake = false;
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, disko, agenix, secrets, chaotic } @inputs:
    let
      user = "ray";
      linuxSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems) f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };
      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName} "$@"
        '')}/bin/${scriptName}";
      };
      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "build-switch-emacs" = mkApp "build-switch-emacs" system;
        "clean" = mkApp "clean" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "install" = mkApp "install" system;
        "install-with-secrets" = mkApp "install-with-secrets" system;
      };
    in
    {
      templates = {
        starter = {
          path = ./templates/starter;
          description = "Starter configuration without secrets";
        };
        starter-with-secrets = {
          path = ./templates/starter-with-secrets;
          description = "Starter configuration with secrets";
        };
      };
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps;
      nixosConfigurations = 
        nixpkgs.lib.genAttrs linuxSystems (system:
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = inputs // { inherit user; };
            modules = [
              disko.nixosModules.disko
              chaotic.nixosModules.default
              home-manager.nixosModules.home-manager {
                home-manager = {
                  sharedModules = [ plasma-manager.homeModules.plasma-manager ]; 
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user} = { config, pkgs, lib, ... }:
                    import ./modules/nixos/home-manager.nix { inherit config pkgs lib inputs; };
                };
              }
              ./hosts/nixos
            ];
          }
        )
        
        {
          garfield = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = inputs // { inherit user; };
            modules = [
              disko.nixosModules.disko
              chaotic.nixosModules.default
              home-manager.nixosModules.home-manager {
                home-manager = {
                  sharedModules = [ plasma-manager.homeModules.plasma-manager ]; 
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user} = { config, pkgs, lib, ... }:
                    import ./modules/nixos/home-manager.nix { inherit config pkgs lib inputs; };
                };
              }
              ./hosts/nixos/garfield
            ];
          };
        };
    };
}
