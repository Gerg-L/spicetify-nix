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
    pkgs = genSystems (system: nixpkgs.legacyPackages.${system});
  in {
    homeManagerModule = pkgs.callPackage ./module.nix {};

    lib = import ./lib {
      inherit pkgs;
      lib = pkgs.lib;
    };

    pkgs = import ./pkgs {
      inherit pkgs;
      lib = pkgs.lib;
    };
  };
}
