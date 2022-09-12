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
    pkgs = genSystems (import nixpkgs {inherit system;});
  in {
    homeManagerModule = import ./module.nix;

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
