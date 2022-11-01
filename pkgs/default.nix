{
  lib,
  fetchgit,
  fetchzip,
  fetchFromGitHub,
  callPackage,
  ...
}: let
  source = callPackage ./source.nix {};
  themes = callPackage ./themes.nix {inherit source;};
  extensions = callPackage ./extensions.nix {inherit source;};
  apps = callPackage ./apps.nix {inherit source;};
in {
  official = {
    themes = themes.official;
    extensions = extensions.official;
    apps = apps.official;
  };
  themes = (builtins.removeAttrs themes ["official"]) // themes.official;
  apps = (builtins.removeAttrs apps ["official"]) // apps.official;
  extensions = (builtins.removeAttrs extensions ["official"]) // extensions.official;
}
