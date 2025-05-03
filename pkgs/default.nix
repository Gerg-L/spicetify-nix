{
  pkgs ? import <nixpkgs> { },
  unfreePkgs ? pkgs,
  ...
}@attrs:
let
  inherit (pkgs) lib;
  json = lib.importJSON ./generated.json;
in
lib.fix (
  self:
  let
    callPackage = lib.callPackageWith (pkgs // self);
    callPackages = lib.callPackagesWith (pkgs // self);
  in
  {
    docs = callPackage ../docs/package.nix { inherit (attrs) self; };
    inherit (json) snippets;

    fetcher = callPackage ./fetcher { };
    sources = callPackages ./npins/sources.nix { };
    spicetifyBuilder = callPackage ./spicetifyBuilder.nix { };

    /*
      Don't want to callPackage these because
      override and overrideDerivation cause issues with the module options
      plus why would you want to override the pre-existing packages
      when they're so simple to make
    */
    extensions = callPackages ./extensions.nix { };

    themes = callPackages ./themes.nix { };

    apps = callPackages ./apps.nix { };

    test =
      let
        spiceLib = import ../lib {
          inherit lib;
          inherit (attrs) self;
        };
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
  }
)
