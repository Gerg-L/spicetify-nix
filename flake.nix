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
    # Don't follows this
    pinned-nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "409f723e01cafc995b9d1f9adcb821c2c8f82491";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pinned-nixpkgs,
      ...
    }:
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

        legacyPackages.${system} = import "${self}/pkgs" { inherit pkgs pinned-nixpkgs self; };

        formatter.${system} = pkgs.nixfmt-rfc-style;

        devShells.${system} = {
          default = pkgs.mkShellNoCC { packages = [ pkgs.npins ]; };
          fetcher = pkgs.mkShell {
            packages = builtins.attrValues { inherit (pkgs) rust-analyzer clippy rustfmt; };
            inputsFrom = [ self.legacyPackages.${system}.fetcher ];
          };
        };
      }
    );
}
