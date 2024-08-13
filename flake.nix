{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    flake-compat = {
      type = "github";
      owner = "edolstra";
      repo = "flake-compat";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      withSystem =
        f:
        lib.fold lib.recursiveUpdate { } (
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
          spicetify = import "${self}/module.nix" {
            inherit self;
            isNixOSModule = false;
          };
          default = self.homeManagerModules.spicetify;
        };

        nixosModules = {
          spicetify = import "${self}/module.nix" {
            inherit self;
            isNixOSModule = true;
          };
          default = self.nixosModules.spicetify;
        };

        legacyPackages.${system} = import "${self}/pkgs" { inherit pkgs self; };

        formatter.${system} = pkgs.nixfmt-rfc-style;

        devShells.${system} = {
          default = pkgs.mkShell { packages = [ pkgs.npins ]; };
          fetcher = pkgs.mkShell {
            packages = builtins.attrValues { inherit (pkgs) rust-analyzer clippy rustfmt; };
            inputsFrom = [ self.legacyPackages.${system}.fetcher ];
          };
        };
      }
    );
}
