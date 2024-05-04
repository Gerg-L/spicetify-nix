{ pkgs, self }:
let
  spicePkgs = self.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  sources = pkgs.callPackages ../npins/sources.nix { };
  spicetify = pkgs.callPackage ./spicetify.nix { };

  /*
    Don't want to callPackage these because 
    override and overrideDerivation cause issues with the module options
    plus why would you want to override the pre-existing packages
    when they're so simple to make
  */
  extensions = import ./extensions.nix {
    inherit (spicePkgs) sources;
    inherit pkgs;
  };
  themes = import ./themes.nix {
    inherit (spicePkgs) sources extensions;
    inherit pkgs;
  };
  apps = import ./apps.nix { inherit (spicePkgs) sources; };
}
