{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      withSystem =
        f:
        nixpkgs.lib.fold nixpkgs.lib.recursiveUpdate { } (
          map f [
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-darwin"
            "x86_64-linux"
          ]
        );
    in
    withSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        homeManagerModules = {
          spicetify = import ./module.nix {
            inherit self;
            isNixOSModule = false;
          };
          default = self.homeManagerModules.spicetify;
        };

        nixosModules = {
          spicetify = import ./module.nix {
            inherit self;
            isNixOSModule = true;
          };
          default = self.nixosModules.spicetify;
        };

        lib.${system} = import ./lib pkgs;

        legacyPackages.${system} = import ./pkgs pkgs;

        formatter.${system} = pkgs.alejandra;

        devShells.${system}.default = pkgs.mkShell { packages = [ pkgs.npins ]; };
      }
    );
}
