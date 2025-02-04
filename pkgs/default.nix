{
  pkgs ? import <nixpkgs> { },
  unfreePkgs ? pkgs,
  docsVersion ? "impure",
}:
let
  inherit (pkgs) lib;
  json = lib.importJSON ./generated.json;
in
lib.fix (self: {
  inherit (json) snippets;

  spicetify-cli = pkgs.callPackage ./spicetify-cli.nix { };

  fetcher = pkgs.callPackage ./fetcher { };
  sources = pkgs.callPackages ./npins/sources.nix { };
  spicetifyBuilder = pkgs.callPackage ./spicetifyBuilder.nix { inherit (self) spicetify-cli; };

  /*
    Don't want to callPackage these because
    override and overrideDerivation cause issues with the module options
    plus why would you want to override the pre-existing packages
    when they're so simple to make
  */
  extensions = import ./extensions.nix {
    inherit (self) sources;
    inherit lib;
  };
  themes = import ./themes.nix {
    inherit (self) sources extensions;
    inherit pkgs lib;
  };
  apps = import ./apps.nix { inherit (self) sources; };

  docs = pkgs.callPackage ../docs { version = docsVersion; };

  test =
    let
      spiceLib = import ../lib lib;
    in
    spiceLib.mkSpicetify unfreePkgs {
      enabledExtensions = builtins.attrValues {
        inherit (self.extensions)
          adblockify
          hidePodcasts
          shuffle
          ;
      };
      theme = self.themes.catppuccin;
      colorScheme = "mocha";
    };
})
