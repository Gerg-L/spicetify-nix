{
  lib,
  callPackage,
  ...
}: {
  extensions,
  apps,
  theme,
  cfgXpui,
  cfgColorScheme,
  cfg,
  ...
}: let
  spiceLib = callPackage ./. {};
  optAttrs = lib.attrsets.optionalAttrs;

  # determine whether or not any extension requires experimental_features
  needExperimental =
    lib.lists.any
    (
      item: (
        if (builtins.hasAttr "experimentalFeatures" item)
        then item.experimentalFeatures
        else false
      )
    )
    extensions;

  allExtensionFiles = map (item: item.filename) extensions;
  extensionString = builtins.concatStringsSep "|" allExtensionFiles;
  allAppsNames = map (item: item.name) apps;
  customAppsString = builtins.concatStringsSep "|" allAppsNames;

  # function which converts a flat nix set of options like injectCss into a
  # xpui structure (sub-sets for AdditionalOptions and Setting etc)
  mkXpuiOverrides = container: let
    boolOverride = set: attrName: cfgName:
      optAttrs (builtins.hasAttr attrName set)
      (optAttrs (set.${attrName} != null)
        (optAttrs (builtins.typeOf set.${attrName} == "bool")
          {${cfgName} = set.${attrName};}));
  in {
    AdditionalOptions = {
      extensions = extensionString;
      custom_apps = customAppsString;
      experimental_features = needExperimental;
    };
    Setting =
      {}
      // boolOverride container "injectCss" "inject_css"
      // boolOverride container "replaceColors" "replace_colors"
      // boolOverride container "overwriteAssets" "overwrite_assets"
      // boolOverride container "sidebarConfig" "sidebar_config"
      # always add the configured color scheme (only cfg provides this)
      // optAttrs (cfgColorScheme != null) {color_scheme = cfgColorScheme;}
      # always add theme name
      // {current_theme = theme.name;};
    Patch =
      optAttrs
      (builtins.hasAttr "patches" theme)
      theme.patches;
    Backup = {version = "Unknown";};
    # backup used to be the following, but I'm pretty sure that in the case of
    # nix, the backup field doesn't matter since it gets built fresh each time
    # Backup = {version = cfg.spotifyPackage.version or "Unknown";};
  };

  # override any values defined by the user in cfg.xpui with values defined by the theme
  overridenXpui1 =
    builtins.mapAttrs
    (name: value: (lib.trivial.mergeAttrs cfgXpui.${name} value))
    (mkXpuiOverrides theme);
  # override any values defined by the theme with values defined in cfg
  overridenXpui2 =
    builtins.mapAttrs
    (name: value: (lib.trivial.mergeAttrs overridenXpui1.${name} value))
    (mkXpuiOverrides cfg);
in
  builtins.toFile "config-xpui.ini"
  (spiceLib.createXpuiINI overridenXpui2)
