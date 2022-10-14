{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  inherit (pkgs) callPackage fetchurl;
  cfg = config.programs.spicetify;
  spiceLib = callPackage ./lib {};
  spiceTypes = spiceLib.types;
  spicePkgs = callPackage ./pkgs {};

  ifTrue = lib.attrsets.optionalAttrs;
  ifTrueList = lib.lists.optionals;
in {
  options.programs.spicetify = {
    enable = mkEnableOption "A modded Spotify";

    theme = mkOption {
      type = types.oneOf [types.str spiceTypes.theme];
      default = "";
    };

    spotifyPackage = mkOption {
      type = types.package;
      default = pkgs.spotify-unwrapped;
      description = "The nix package containing Spotify Desktop.";
    };

    spicetifyPackage = mkOption {
      type = types.package;
      default = pkgs.spicetify-cli;
      description = "The nix package containing spicetify-cli.";
    };

    extraCommands = mkOption {
      type = types.lines;
      default = "";
      description = "Extra commands to be run during the setup of spicetify.";
    };

    enabledExtensions = mkOption {
      type = types.listOf (types.oneOf [spiceTypes.extension types.str]);
      default = [];
      description = "A list of extensions. Official extensions such \
      as \"dribbblish.js\" can be referenced by string alone.";
      example = ''
        [
          "dribbblish.js"
          "shuffle+.js"
          {
            src = pkgs.fetchgit {
              url = "https://github.com/LucasBares/spicetify-last-fm";
              rev = "0f905b49362ea810b6247ac1950a2951dd35632e";
              sha256 = "1b0l2g5cyjj1nclw1ff7as9q94606mkq1k8l2s34zzdsx3m2zv81";
            };
            filename = "lastfm.js";
          }
        ]
      '';
    };
    enabledCustomApps = mkOption {
      type = types.listOf (types.oneOf [spiceTypes.app types.str]);
      default = [];
    };

    xpui = mkOption {
      type = spiceTypes.xpui;
      default = {};
    };

    # legacy/ease of use options (commonly set for themes like Dribbblish)
    # injectCss = xpui.Setting.inject_css;
    injectCss = mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };
    replaceColors = mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };
    overwriteAssets = mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };
    sidebarConfig = mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };
    colorScheme = mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    customColorScheme = mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
    };

    cssMap = mkOption {
      type = lib.types.path;
      default = fetchurl {
        url = "https://raw.githubusercontent.com/spicetify/spicetify-cli/6f473f28151c75e08e83fb280dd30fadd22d9c04/css-map.json";
        sha256 = "1qj0hlq98hz4v318qhz6ijyrir96fj962gqz036dm4jka3bg06l7";
      };
    };
  };

  config = let
    actualTheme = spiceLib.getTheme cfg.theme;

    # helper functions
    pipeConcat = foldr (a: b: a + "|" + b) "";
    lineBreakConcat = foldr (a: b: a + "\n" + b) "";

    # take the list of extensions and turn strings into actual extensions
    allExtensions = map spiceLib.getExtension (cfg.enabledExtensions
      ++ (
        ifTrueList (builtins.hasAttr "requiredExtensions" actualTheme)
        actualTheme.requiredExtensions
      )
      ++ cfg.xpui.AdditionalOptions.extensions);
    allExtensionFiles = map (item: item.filename) allExtensions;
    extensionString = pipeConcat allExtensionFiles;

    # do the same thing again but for customapps this time
    allApps =
      map spiceLib.getApp
      (cfg.enabledCustomApps ++ cfg.xpui.AdditionalOptions.custom_apps);
    allAppsNames = map (item: item.name) allApps;
    customAppsString = pipeConcat allAppsNames;

    # cfg.theme.injectCss is a submodule but cfg.injectCss is not, so we
    # have to have two different override functions for each case
    # (one value is null while the other is undefined...)
    createBoolOverride = set: attrName: cfgName:
      ifTrue (set.${attrName} != null)
      (ifTrue (builtins.typeOf set.${attrName} == "bool")
        {${cfgName} = set.${attrName};});
    createBoolOverrideFromSubmodule = set: attrName: cfgName:
      ifTrue (builtins.hasAttr attrName set)
      (ifTrue (builtins.typeOf set.${attrName} == "bool")
        {${cfgName} = set.${attrName};});

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
      allExtensions;

    mkXpuiOverrides = let
      createOverride = set: attrName: cfgName:
        ifTrue (set.${attrName} != null)
        {${cfgName} = set.${attrName};};
    in
      container: boolOverrideFunc: {
        AdditionalOptions = {
          extensions = extensionString;
          custom_apps = customAppsString;
          experimental_features = needExperimental;
        };
        Setting =
          {}
          // boolOverrideFunc container "injectCss" "inject_css"
          // boolOverrideFunc container "replaceColors" "replace_colors"
          // boolOverrideFunc container "overwriteAssets" "overwrite_assets"
          // boolOverrideFunc container "sidebarConfig" "sidebar_config"
          # also add the colorScheme as an override if defined in cfg
          // (ifTrue (container == cfg) (createOverride container
              "colorScheme" "color_scheme"))
          # and turn the theme into a string of its name
          // (ifTrue (container == cfg) {current_theme = actualTheme.name;});
        Patch = ifTrue (container == actualTheme) (ifTrue
          (builtins.hasAttr "patches" actualTheme)
          actualTheme.patches);
        Backup = {version = cfg.spotifyPackage.version or "Unknown";};
      };

    # override any values defined by the user in cfg.xpui with values defined by the theme
    overridenXpui1 =
      builtins.mapAttrs
      (name: value: (lib.trivial.mergeAttrs cfg.xpui.${name} value))
      (mkXpuiOverrides actualTheme createBoolOverrideFromSubmodule);
    # override any values defined by the theme with values defined in cfg
    overridenXpui2 =
      builtins.mapAttrs
      (name: value: (lib.trivial.mergeAttrs overridenXpui1.${name} value))
      (mkXpuiOverrides cfg createBoolOverride);

    config-xpui =
      builtins.toFile "config-xpui.ini"
      (spiceLib.createXpuiINI overridenXpui2);

    # INI created, now create the postInstall that runs spicetify
    inherit (lib.lists) foldr;
    inherit (lib.attrsets) mapAttrsToList;

    extensionCommands = lineBreakConcat (map
      (
        item: let
          command = "cp -rn ${
            item.src
          }/${item.filename} ./Extensions/${item.filename}";
        in "${command} && echo \"Cp command for ${item.filename} succeeded!\""
      )
      allExtensions);

    customAppCommands = lineBreakConcat (map
      (item: "cp -rn ${(
        if (builtins.hasAttr "appendName" item)
        then
          if (item.appendName)
          then "${item.src}/${item.name}"
          else "${item.src}"
        else "${item.src}"
      )} ./CustomApps/${item.name}")
      allApps);

    spicetify = "spicetify-cli --no-restart";
    themePath = spiceLib.getThemePath actualTheme;

    customColorSchemeINI =
      builtins.toFile "dummy-color.ini"
      (spiceLib.createXpuiINI
        {custom = cfg.customColorScheme;});

    customColorSchemeScript =
      if (cfg.customColorScheme != null)
      then ''
        COLORINI=./Themes/${actualTheme.name}/color.ini
        if [ -e $COLORINI ]; then
            echo "" >> $COLORINI
            # finally, use cat for its actual purpose: concatenation
            cat ${customColorSchemeINI} >> $COLORINI
        fi
      ''
      else "";

    extraCss = builtins.toFile "extra.css" (
      if builtins.hasAttr "additionalCss" actualTheme
      then actualTheme.additionalCss
      else ""
    );

    finalScript = ''
      export SPICETIFY_CONFIG=$out/share/spicetify
      mkdir -p $SPICETIFY_CONFIG

      # move spicetify bin here
      cp ${cfg.spicetifyPackage}/bin/spicetify-cli $SPICETIFY_CONFIG/spicetify-cli
      ${pkgs.coreutils-full}/bin/chmod +x $SPICETIFY_CONFIG/spicetify-cli
      cp -r ${cfg.spicetifyPackage}/bin/jsHelper $SPICETIFY_CONFIG/jsHelper
      # grab the css map
      cp -r ${cfg.cssMap} $SPICETIFY_CONFIG/css-map.json
      # add the current directory to path
      export PATH=$SPICETIFY_CONFIG:$PATH

      pushd $SPICETIFY_CONFIG

      # create config and prefs
      cp ${config-xpui} config-xpui.ini
      ${pkgs.coreutils-full}/bin/chmod a+wr config-xpui.ini
      touch $out/share/spotify/prefs

      # replace the spotify path with the current derivation's path
      sed -i "s|__REPLACEME__|$out/share/spotify|g" config-xpui.ini
      sed -i "s|__REPLACEME2__|$out/share/spotify/prefs|g" config-xpui.ini

      mkdir -p Themes
      mkdir -p Extensions
      mkdir -p CustomApps
      cp -r ${themePath} ./Themes/${actualTheme.name}
      ${pkgs.coreutils-full}/bin/chmod -R a+wr Themes
      echo "copied theme"
      cat ${extraCss} >> ./Themes/${actualTheme.name}/user.css
      echo "applied additionalCss to theme"
      # copy extensions into Extensions folder
      ${extensionCommands}
      ${pkgs.coreutils-full}/bin/chmod -R a+wr Extensions
      # copy custom apps into CustomApps folder
      ${customAppCommands}
      ${pkgs.coreutils-full}/bin/chmod -R a+wr CustomApps
      # completed app and extension installation
      # add a custom color scheme if necessary
      ${customColorSchemeScript}
      # completed custom color scheme addition
      ${cfg.extraCommands}

      # extra commands that the theme might need
      ${
        if (builtins.hasAttr "extraCommands" actualTheme)
        then
          (
            if actualTheme.extraCommands != null
            then actualTheme.extraCommands
            else ""
          )
        else ""
      }
      popd
      ${spicetify} backup apply
      rm $out/snap.yaml
    '';

    # custom spotify package with spicetify integrated in
    spiced-spotify = cfg.spotifyPackage.overrideAttrs (oldAttrs: rec {
      postInstall = finalScript;
    });
  in
    mkIf cfg.enable {
      # install necessary packages for this user
      home.packages = with cfg;
        [
          spiced-spotify
        ]
        ++
        # need montserrat for the BurntSienna theme
        (
          ifTrueList
          (actualTheme == spicePkgs.official.themes.BurntSienna)
          [pkgs.montserrat]
        )
        ++ (
          ifTrueList
          (actualTheme == spicePkgs.themes.Orchis)
          [pkgs.fira]
        );
    };
}
