{
  description = "A nix flake that provides a home-manager module to configure spicetify with.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    spicetify-themes = {
      url = "github:morpheusthewhite/spicetify-themes";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, spicetify-themes, ... }@inputs:
    {
      homeManagerModule = import ./module.nix;
    };
}
