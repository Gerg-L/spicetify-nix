{
  callPackage,
  lib,
  ...
}: let
  spicePkgs = callPackage ../pkgs {};
in {
  types = callPackage ./types.nix {};

  createXpuiINI = lib.generators.toINI {
    # specifies how to format a key/value pair
    mkKeyValue =
      lib.generators.mkKeyValueDefault
      {
        # specifies the generated string for a subset of nix values
        mkValueString = v:
          if v == true
          then "1"
          else if v == false
          then "0"
          # else if isString v then ''"${v}"''
          # and delegates all other values to the default generator
          else lib.generators.mkValueStringDefault {} v;
      } "=";
  };

  spicetifyBuilder = callPackage ./spicetify-builder.nix {};

  xpuiBuilder = callPackage ./xpui-builder.nix {};

  getThemePath = theme:
    if (builtins.hasAttr "appendName" theme)
    then
      (
        if theme.appendName
        then "${theme.src}/${theme.name}"
        else theme.src
      )
    else theme.src;

  # same thing but if its a string it looks it up in the default pkgs
  getTheme = theme:
    if builtins.typeOf theme == "string"
    then
      (
        if builtins.hasAttr theme spicePkgs.themes
        then
          (lib.trivial.warn
            ''
              Using a string like so:
              programs.spicetify.theme = "${theme}";
              is deprecated. Please use the following format:
              programs.spicetify.theme = let
                spicePkgs = spicetify-nix.packages.${"$\{pkgs.system}"}.default;
              in
                spicePkgs.themes.${theme};
            ''
            spicePkgs.themes.${theme})
        else throw "Unknown theme ${theme}. Try using the lib.theme type instead of a string."
      )
    else if theme == null
    then
      lib.trivial.warn
      "spicetify: null theme passed to getTheme, assuming official.Default"
      spicePkgs.themes.official.Default
    else theme;

  getExtension = ext:
    if builtins.typeOf ext == "string"
    then
      (
        if builtins.hasAttr ext spicePkgs.extensions
        then
          (lib.trivial.warn
            ''
              Using a string like so:
              programs.spicetify.enabledExtensions = [ "${ext}" ];
              is deprecated. Please use the following format:
              programs.spicetify.enabledExtensions = let
                spicePkgs = spicetify-nix.packages.${"$\{pkgs.system}"}.default;
              in
                with spicePkgs.extensions [ ${spicePkgs.extensions._lib.sanitizeName ext} ];
            ''
            spicePkgs.extensions.${ext})
        else throw "Unknown extension ${ext}. Try using the lib.extension type instead of a string."
      )
    else ext;

  getApp = app:
    if builtins.typeOf app == "string"
    then
      (
        if builtins.hasAttr app spicePkgs.apps
        then
          (
            lib.trivial.warn
            ''
              Using a string like so:
              programs.spicetify.enabledCustomApps = [ "${app}" ];
              is deprecated. Please use the following format:
              programs.spicetify.enabledCustomApps = let
                spicePkgs = spicetify-nix.packages.${"$\{pkgs.system}"}.default;
              in
                with spicePkgs.apps [ ${app} ];
            ''
            spicePkgs.apps.${app}
          )
        else throw "Unknown CustomApp ${app}. Try using the lib.app type instead of a string."
      )
    else app;
}
