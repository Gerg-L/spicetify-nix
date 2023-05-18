{
  description = "A nix flake that provides a home-manager module to configure spicetify with.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    {
      homeManagerModules = {
        spicetify = (import ./module.nix) {
          isNixOSModule = false;
        };
        default = self.homeManagerModules.spicetify;
      };

      nixosModules = {
        spicetify = import ./module.nix {
          isNixOSModule = true;
        };
        default = self.nixosModules.spicetify;
      };

      # nice aliases
      homeManagerModule = self.homeManagerModules.default;
      nixosModule = self.nixosModules.default;

      templates.default = {
        path = ./template;
        description = "A basic home-manager configuration which installs spicetify with the Dribbblish theme.";
      };
    }
    # legacy stuff thats just for x86_64 linux
    // (
      let
        legacyPkgs = import nixpkgs {system = flake-utils.lib.system.x86_64-linux;};
      in {
        pkgs =
          nixpkgs.lib.warn
          "spicetify-nix.pkgs is deprecated, use spicetify-nix.packages.\${pkgs.system}"
          (legacyPkgs.callPackage ./pkgs {});
        lib =
          nixpkgs.lib.warn
          "spicetify-nix.lib is deprecated, use spicetify-nix.libs.\${pkgs.system}"
          (legacyPkgs.callPackage ./lib {});
      }
    )
    // flake-utils.lib.eachSystem
    (
      let
        inherit (flake-utils.lib) system;
      in [
        system.aarch64-linux
        system.x86_64-linux
      ]
    )
    (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      libs = pkgs.callPackage ./lib {};

      packages = {
        spicetify = pkgs.callPackage ./pkgs {};
        default = self.packages.${system}.spicetify;
      };

      checks = {
        all-tests = pkgs.callPackage ./tests {};
        minimal-config = pkgs.callPackage ./tests/minimal-config.nix {};
        default = self.checks.${system}.all-tests;
      };

      formatter = pkgs.alejandra;

      # DEPRECATED ---------------------------------------------------------------

      pkgSets =
        nixpkgs.lib.warn
        "spicetify-nix.pkgSets is deprecated, use spicetify-nix.packages.\${pkgs.system}.default"
        self.packages.${system}.default;

      devShells = {
        default = pkgs.mkShell {
          packages = [
            pkgs.nvfetcher
          ];
        };
      };
    });
}
