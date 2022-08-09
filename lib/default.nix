{ pkgs, lib, ... }:
let
  customToINI = lib.generators.toINI {
    # specifies how to format a key/value pair
    mkKeyValue = lib.generators.mkKeyValueDefault
      {
        # specifies the generated string for a subset of nix values
        mkValueString = v:
          if v == true then "1"
          else if v == false then "0"
          # else if isString v then ''"${v}"''
          # and delegates all other values to the default generator
          else lib.generators.mkValueStringDefault { } v;
      } "=";
  };

  spicePkgs = import ../pkgs { inherit pkgs lib; };
in
{
  types = import ./types.nix { inherit pkgs lib; };

  createXpuiINI = xpui: (customToINI xpui);

  getThemePath = theme:
    if (builtins.hasAttr "appendName" theme) then
      (if theme.appendName then
        "${theme.src}/${theme.name}"
      else
        theme.src)
    else
      theme.src;

  # same thing but if its a string it looks it up in the default pkgs
  getTheme = theme:
    if builtins.typeOf theme == "string" then
      (
        if builtins.hasAttr theme spicePkgs.themes then
          spicePkgs.themes.${theme}
        else
          throw "Unknown theme ${theme}. Try using the lib.theme type instead of a string."
      )
    else theme;

  getExtension = ext:
    if builtins.typeOf ext == "string" then
      (
        if builtins.hasAttr ext spicePkgs.extensions then
          spicePkgs.extensions.${ext}
        else
          throw "Unknown extension ${ext}. Try using the lib.extension type instead of a string."
      )
    else
      ext;

  getApp = app:
    if builtins.typeOf app == "string" then
      (
        if builtins.hasAttr app spicePkgs.apps then
          spicePkgs.apps.${app}
        else
          throw "Unknown CustomApp ${app}. Try using the lib.app type instead of a string."
      )
    else
      app;
}
