{ pkgs, inputs }:
let
  inherit (pkgs) lib;
  spicePkgs = inputs.self.legacyPackages.${pkgs.stdenv.system};
  json = lib.importJSON ./generated.json;
  spicetify-cli = pkgs.callPackage ./spicetify-cli.nix { };
in
{
  inherit (json) snippets;
  inherit spicetify-cli;

  fetcher = pkgs.callPackage ./fetcher { };
  sources = pkgs.callPackages ./npins/sources.nix { };
  spicetifyBuilder = pkgs.callPackage ./spicetifyBuilder.nix { inherit spicetify-cli; };

  /*
    Don't want to callPackage these because
    override and overrideDerivation cause issues with the module options
    plus why would you want to override the pre-existing packages
    when they're so simple to make
  */
  extensions = import ./extensions.nix {
    inherit (spicePkgs) sources;
    inherit lib;
  };
  themes = import ./themes.nix {
    inherit (spicePkgs) sources extensions;
    inherit pkgs lib;
  };
  apps = import ./apps.nix { inherit (spicePkgs) sources; };

  docs = pkgs.callPackage ../docs { inherit inputs; };
}
