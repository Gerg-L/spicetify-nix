{
  description = "A nix flake that provides a home-manager module to configure spicetify with.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    gennedPkgs = genSystems (system: import nixpkgs {inherit system;});

    # legacy reasons...
    defaultSystem = "x86_64-linux";
  in {
    libs = genSystems (
      system: (gennedPkgs.${system}.callPackage ./lib {})
    );

    packages = genSystems (system: {
      spicetify = gennedPkgs.${system}.callPackage ./pkgs {};
      default = self.packages.${system}.spicetify;
    });

    homeManagerModules = {
      spicetify = (import ./module.nix) {isNixOSModule = false;};
      default = self.homeManagerModules.spicetify;
    };

    nixosModules = {
      spicetify = import ./module.nix {isNixOSModule = true;};
      default = self.nixosModules.spicetify;
    };

    # nice aliases
    homeManagerModule = self.homeManagerModules.default;
    nixosModule = self.nixosModules.default;

    templates.default = {
      path = ./template;
      description = "A basic home-manager configuration which installs spicetify with the Dribbblish theme.";
    };

    formatter = genSystems (system: gennedPkgs.${system}.alejandra);

    # DEPRECATED ---------------------------------------------------------------

    pkgSets = genSystems (system: (
      nixpkgs.lib.warn
      "spicetify-nix.pkgSets is deprecated, use spicetify-nix.packages.\${pkgs.system}.default"
      self.packages.${system}.default
    ));

    # legacy stuff thats just for x86_64 linux
    pkgs =
      nixpkgs.lib.warn
      "spicetify-nix.pkgs is deprecated, use spicetify-nix.packages.\${pkgs.system}"
      (gennedPkgs.${defaultSystem}.callPackage ./pkgs {});
    lib =
      nixpkgs.lib.warn
      "spicetify-nix.lib is deprecated, use spicetify-nix.libs.\${pkgs.system}"
      (gennedPkgs.${defaultSystem}.callPackage ./lib {});
  };
}
