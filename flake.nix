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
    # legacy version thats just for x86_64 linux
    homeManagerModule = pkgs.${defaultSystem}.callPackage ./module.nix {};

    lib = import ./lib {
      inherit pkgs;
      lib = pkgs.lib;
    };

    pkgs = import ./pkgs {
      inherit pkgs;
      lib = pkgs.lib;
    };

    # version which supports aarch64
    homeManagerModules = genSystems (system: pkgs.${system}.callPackage ./module.nix {});

    libs = genSystems (
      system: (pkgs.${system}.callPackage ./lib {})
    );
    pkgSets = genSystems (
      system: (pkgs.${system}.callPackage ./pkgs {})
    );
  };
}
