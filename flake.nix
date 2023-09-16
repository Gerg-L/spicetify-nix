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
      #unfreePkgs = import nixpkgs {
      #  inherit system;
      #  config.allowUnfreePredicate = pkg:
      #    builtins.elem (nixpkgs.lib.getName pkg) [
      #      "spotify"
      #      "spicetify-Bloom"
      #    ];
      #};
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

      lib.${system} = pkgs.callPackage ./lib {};

      legacyPackages.${system} = pkgs.callPackage ./pkgs {};

      #checks.${system} = {
      #  default = self.checks.${system}.all-tests;
      #  all-tests = unfreePkgs.callPackage ./tests {};
      #  minimal-config = unfreePkgs.callPackage ./tests/minimal-config.nix {};
      #  all-for-theme = unfreePkgs.callPackage ./tests/all-for-theme.nix {};
      #  apps = unfreePkgs.callPackage ./tests/apps.nix {};
      #  all-exts-and-apps =
      #    builtins.mapAttrs
      #    (_: self.checks.${system}.all-for-theme)
      #    (builtins.removeAttrs
      #      (unfreePkgs.callPackage ./pkgs {}).themes
      #      ["override" "overrideDerivation"]);
      #};

      formatter.${system} = pkgs.alejandra;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.npins
        ];
      };
    });
}
