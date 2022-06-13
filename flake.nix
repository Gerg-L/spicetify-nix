{
  description = "A nix flake that provides a home-manager module to configure spicetify with.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;

    spicetify-themes = {
      url = "github:morpheusthewhite/spicetify-themes";
      flake = false;
    };
  };

  outputs = { self, flake-utils, nixpkgs, spicetify-themes, ... }@inputs:
    {
      homeManagerModule = import ./module.nix {
        inherit self;
        config = nixpkgs.config;
        lib = nixpkgs.lib;
        pkgs = flake-utils.lib.eachDefaultSystem (system:
          import nixpkgs { inherit system; }
        );
        inherit spicetify-themes;
      };
    };
}
