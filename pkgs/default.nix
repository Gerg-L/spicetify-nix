{ pkgs, self }:
let
  inherit (pkgs) lib;
  spicePkgs = self.legacyPackages.${pkgs.stdenv.system};
  json = lib.importJSON ./generated.json;
in
{
  inherit (json) snippets;
  fetcher = pkgs.callPackage ./fetcher { };
  sources = pkgs.callPackages ./npins/sources.nix { };
  spicetifyBuilder = pkgs.callPackage ./spicetifyBuilder.nix { };

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
}
