{
  callPackage,
  lib,
  stdenvNoCC,
  emptyDirectory,
  ...
}: let
  spicePkgs = callPackage ../pkgs {};
  tryAllExtensionsAndAppsFor = callPackage ./all-for-theme.nix {};

  themes = builtins.removeAttrs spicePkgs.themes ["override" "overrideDerivation"];
  drvs =
    (lib.attrsets.mapAttrsToList (_: value: tryAllExtensionsAndAppsFor value) themes)
    ++ (callPackage ./minimal-config.nix {});
  lnCommands = builtins.concatStringsSep "\n" (map (drv: "ln -sf ${drv} $out/") drvs);
in
  stdenvNoCC.mkDerivation {
    name = "spicetify-tests";
    src = emptyDirectory;
    dontBuild = true;

    installPhase = "mkdir -p $out\n" + lnCommands;
  }
