{
  description = "A nix flake that provides a home-manager module to configure spicetify with.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = genSystems (system: import nixpkgs {inherit system;});

    # legacy reasons...
    defaultSystem = "x86_64-linux";
  in {
    homeManagerModule = import ./module.nix;

    # legacy stuff thats just for x86_64 linux
    pkgs = pkgs.${defaultSystem}.callPackage ./pkgs {};
    lib = pkgs.${defaultSystem}.callPackage ./lib {};

    # version which supports aarch64
    libs = genSystems (
      system: (pkgs.${system}.callPackage ./lib {})
    );
    pkgSets = genSystems (
      system: (pkgs.${system}.callPackage ./pkgs {})
    );
  };
}
