{ pkgs, self }:
let
  inherit (pkgs) lib;
  spicePkgs = self.legacyPackages.${pkgs.stdenv.system};
  json = lib.importJSON "${self}/pkgs/generated.json";
in
{
  inherit (json) snippets;
  fetcher = pkgs.callPackage ./fetcher { inherit self; };
  sources = pkgs.callPackages "${self}/pkgs/npins/sources.nix" { };
  spicetifyBuilder = pkgs.callPackage "${self}/pkgs/spicetifyBuilder.nix" { };

  /*
    Don't want to callPackage these because
    override and overrideDerivation cause issues with the module options
    plus why would you want to override the pre-existing packages
    when they're so simple to make
  */
  extensions = import "${self}/pkgs/extensions.nix" {
    inherit (spicePkgs) sources;
    inherit lib;
  };
  themes = import "${self}/pkgs/themes.nix" {
    inherit (spicePkgs) sources extensions;
    inherit pkgs lib;
  };
  apps = import "${self}/pkgs/apps.nix" { inherit (spicePkgs) sources; };
}
