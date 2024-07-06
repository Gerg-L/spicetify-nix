{ pkgs, self }:
let
  inherit (pkgs) lib;
  spicePkgs = self.legacyPackages.${pkgs.stdenv.system};
in
{
  sources = lib.mapAttrs (_: pkgs.npins.mkSource) (lib.importJSON "${self}/pkgs/sources.json").pins;
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
      name = lib.pipe x.preview [
        (lib.removePrefix "resources/assets/snippets/")
        (x: builtins.substring 0 ((builtins.stringLength x) - 4) x)
      ];
      value = x.code;
    }))
    builtins.listToAttrs
  ];
}
