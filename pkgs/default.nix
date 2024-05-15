{ pkgs, self }:
let
  spicePkgs = self.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  sources = pkgs.callPackages "${self}/npins/sources.nix" { inherit self; };
  spicetify = pkgs.callPackage "${self}/pkgs/spicetify.nix" { };

  /*
    Don't want to callPackage these because
    override and overrideDerivation cause issues with the module options
    plus why would you want to override the pre-existing packages
    when they're so simple to make
  */
  extensions = import "${self}/pkgs/extensions.nix" {
    inherit (spicePkgs) sources;
    inherit pkgs;
  };
  themes = import "${self}/pkgs/themes.nix" {
    inherit (spicePkgs) sources extensions;
    inherit pkgs;
  };
  apps = import "${self}/pkgs/apps.nix" { inherit (spicePkgs) sources; };
}
