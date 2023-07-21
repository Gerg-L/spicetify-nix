{
  description = "A nix flake that provides a home-manager module to configure spicetify with.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    withSystem = f:
      nixpkgs.lib.fold nixpkgs.lib.recursiveUpdate {}
      (map f ["x86_64-linux" "aarch64-linux"]);
  in
    withSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeManagerModules = {
        spicetify = import ./module.nix {
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

      libs.${system} = pkgs.callPackage ./lib {};

      legacyPackages.${system} = pkgs.callPackage ./pkgs {};

      checks.${system} = {
        all-tests = pkgs.callPackage ./tests {};
        minimal-config = pkgs.callPackage ./tests/minimal-config.nix {};
        all-for-theme = pkgs.callPackage ./tests/all-for-theme.nix {};
        apps = pkgs.callPackage ./tests/apps.nix {};
        default = self.checks.${system}.all-tests;
        all-exts-and-apps =
          builtins.mapAttrs
          (_: self.checks.${system}.all-for-theme)
          (builtins.removeAttrs
            (pkgs.callPackage ./pkgs {}).themes
            ["override" "overrideDerivation"]);
      };

      formatter.${system} = pkgs.alejandra;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nvfetcher
        ];
      };
    });
}
