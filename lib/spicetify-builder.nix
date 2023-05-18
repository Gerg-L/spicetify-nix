{
  lib,
  coreutils-full,
  callPackage,
  ...
}: {
  spotify,
  spicetify,
  config-xpui,
  theme,
  usingCustomColorScheme ? false,
  customColorScheme ? {},
  cssMap ? "${spicetify.src}/css-map.json",
  extensions ? [],
  apps ? [],
  extraCommands ? "",
  ...
}: let
  inherit (lib.strings) optionalString;
  spiceLib = callPackage ./. {};

  # add extra css if theme requires
  extraCss = builtins.toFile "extra.css" (
    optionalString
    (builtins.hasAttr "additionalCss" theme)
    theme.additionalCss
  );
  # add custom color scheme if configured
  customColorSchemeScript = let
    customColorSchemeINI =
      builtins.toFile "dummy-color.ini"
      (spiceLib.createXpuiINI
        {custom = customColorScheme;});
  in
    optionalString usingCustomColorScheme ''
      mkdir -p Themes/${theme.name}
      echo -en '\n' >> Themes/${theme.name}/color.ini
      cat ${customColorSchemeINI} >> Themes/${theme.name}/color.ini
    '';

  extensionCommands = builtins.concatStringsSep "\n" (map
    (
      item: let
        command = "cp -rn ${
          item.src
        }/${item.filename} ./Extensions/${item.filename}";
      in "${command} || echo \"Copying extension ${item.filename} failed.\""
    )
    extensions);

  customAppCommands = builtins.concatStringsSep "\n" (map
    (item: let
      command = "cp -rn ${(
        if (builtins.hasAttr "appendName" item)
        then
          if (item.appendName)
          then "${item.src}/${item.name}"
          else "${item.src}"
        else "${item.src}"
      )} ./CustomApps/${item.name}";
    in "${command} || echo \"Copying custom app ${item.name} failed.\"")
    apps);

  spicetifyCmd = "spicetify-cli --no-restart";
in
  spotify.overrideAttrs (_: {
    name = "spicetify-${theme.name}";
    postInstall = ''
      set -e
      export SPICETIFY_CONFIG=$out/share/spicetify
      mkdir -p $SPICETIFY_CONFIG

      # move spicetify bin here
      cp ${spicetify}/bin/spicetify-cli $SPICETIFY_CONFIG/spicetify-cli
      ${coreutils-full}/bin/chmod +x $SPICETIFY_CONFIG/spicetify-cli
      cp -r ${spicetify}/bin/jsHelper $SPICETIFY_CONFIG/jsHelper
      # grab the css map
      cp -r ${cssMap} $SPICETIFY_CONFIG/css-map.json
      # add the current directory to path
      export PATH=$SPICETIFY_CONFIG:$PATH

      pushd $SPICETIFY_CONFIG

      # create config and prefs
      cp ${config-xpui} config-xpui.ini
      ${coreutils-full}/bin/chmod a+wr config-xpui.ini
      touch $out/share/spotify/prefs

      # replace the spotify path with the current derivation's path
      sed -i "s|__REPLACEME__|$out/share/spotify|g" config-xpui.ini
      sed -i "s|__REPLACEME2__|$out/share/spotify/prefs|g" config-xpui.ini

      mkdir -p Themes
      cp -r ${spiceLib.getThemePath theme} ./Themes/${theme.name} || echo "Copying theme ${theme.name} failed"
      ${coreutils-full}/bin/chmod -R a+wr Themes
      echo "copied theme"
      cat ${extraCss} >> ./Themes/${theme.name}/user.css
      echo "applied additionalCss to theme"

      # copy extensions into Extensions folder
      mkdir -p Extensions
      ${extensionCommands}
      ${coreutils-full}/bin/chmod -R a+wr Extensions

      # copy custom apps into CustomApps folder
      mkdir -p CustomApps
      ${customAppCommands}
      ${coreutils-full}/bin/chmod -R a+wr CustomApps

      # completed app and extension installation
      # add a custom color scheme if necessary
      ${customColorSchemeScript}
      # completed custom color scheme addition
      ${extraCommands}

      # extra commands that the theme might need
      ${
        optionalString
        (builtins.hasAttr "extraCommands" theme && theme.extraCommands != null)
        theme.extraCommands
      }
      popd > /dev/null
      ${spicetifyCmd} backup apply
      rm $out/snap.yaml
    '';
  })
