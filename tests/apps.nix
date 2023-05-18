{
  lib,
  callPackage,
  spicetify-cli,
  spotify,
  ...
}: let
  spiceLib = callPackage ../lib {};
  spicePkgs = callPackage ../pkgs {};

  flatten = lib.attrsets.mapAttrsToList (_: value: value);
  apps = flatten (builtins.removeAttrs spicePkgs.apps ["override" "overrideDerivation"]);

  theme = spicePkgs.official.themes.Default;

  config-xpui = spiceLib.xpuiBuilder {
    inherit apps theme;
    cfgXpui = spiceLib.types.defaultXpui;
    cfgColorScheme = null;
    cfg = {};
    extensions = [];
  };
in
  spiceLib.spicetifyBuilder {
    inherit spotify config-xpui apps theme;
    spicetify = spicetify-cli;
  }
