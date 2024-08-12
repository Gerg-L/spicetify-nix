{ pkgs, self }:
let
  inherit (pkgs) lib;
  spicePkgs = self.legacyPackages.${pkgs.stdenv.system};
in
{
  sources = pkgs.callPackages "${self}/pkgs/npins/sources.nix" { };
  spicetify = pkgs.callPackage "${self}/pkgs/spicetify.nix" { };

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
  snippets = lib.pipe ./snippets.json [
    lib.importJSON
    (map (x: {
      name = with lib; pipe x.preview [(splitString ".") init concatStrings toLower baseNameOf];
      value = x.code;
    }))
    builtins.listToAttrs
  ];
}
