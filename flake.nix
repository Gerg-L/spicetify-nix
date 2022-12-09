{
  description = "A nix flake that provides a home-manager module to configure spicetify with.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = genSystems (system: import nixpkgs {inherit system;});

    # legacy reasons...
    defaultSystem = "x86_64-linux";
  in {
    libs = genSystems (
      system: (pkgs.${system}.callPackage ./lib {})
    );

    packages = genSystems (system: {
      spicetify = pkgs.${system}.callPackage ./pkgs {};
      default = self.packages.${system}.spicetify;
    });

    homeManagerModules = {
      spicetify = import ./module.nix;
      default = self.homeManagerModules.spicetify;
    };

    templates.default = {
      path = ./template;
      description = "A basic home-manager configuration which installs spicetify with the Dribbblish theme.";
    };

    # DEPRECATED ---------------------------------------------------------------

    pkgSets = genSystems (system: (
      nixpkgs.lib.warn
      "spicetify-nix.pkgSets is deprecated, use spicetify-nix.packages.\${pkgs.system}.default"
      self.packages.${system}.default
    ));

    homeManagerModule =
      nixpkgs.lib.warn
      "spicetify-nix.homeManagerModule is deprecated, use spicetify-nix.homeManagerModules.default"
      self.homeManagerModules.default;

    # legacy stuff thats just for x86_64 linux
    pkgs =
      nixpkgs.lib.warn
      "spicetify-nix.pkgs is deprecated, use spicetify-nix.packages.\${pkgs.system}"
      (pkgs.${defaultSystem}.callPackage ./pkgs {});
    lib =
      nixpkgs.lib.warn
      "spicetify-nix.lib is deprecated, use spicetify-nix.libs.\${pkgs.system}"
      (pkgs.${defaultSystem}.callPackage ./lib {});
  };
}
