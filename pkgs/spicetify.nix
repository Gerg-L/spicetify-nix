{
  lib,
  stdenv,
  spotify,
  spicetify-cli,

  theme ? throw "",
  config-xpui ? throw "",
  usingCustomColorScheme ? false,
  customColorScheme ? { },
  cssMap ? "${spicetify-cli.src}/css-map.json",
  extensions ? [ ],
  apps ? [ ],
  extraCommands ? "",
}:
let

  extensionCommands = lib.concatLines (
    map (item: "cp -rn ${item.src}/${item.filename} Extensions/${item.filename}") extensions
  );

  customAppCommands = lib.concatLines (
    map
      (
        item:
        "cp -rn ${
          (
            if item ? appendName then
              if item.appendName then "${item.src}/${item.name}" else item.src
            else
              item.src
          )
        } CustomApps/${item.name}"
      )
      apps
  );

  spotifyPath =
    if stdenv.isLinux then
      "$out/share/spotify"
    else if stdenv.isDarwin then
      "$out/Applications/Spotify.app/Contents/Resources"
    else
      throw "";

  themePath =
    if (builtins.hasAttr "appendName" theme) then
      (if theme.appendName then "${theme.src}/${theme.name}" else theme.src)
    else
      theme.src;
in
spotify.overrideAttrs (
  old: {
    name = "spicetify-${theme.name}";

    postInstall =
      (old.postInstall or "")
      + ''
         export SPICETIFY_CONFIG=$PWD

         cp ${lib.getExe spicetify-cli} spicetify-cli 
         ln -s ${lib.getExe' spicetify-cli "jsHelper"} jsHelper
         ln -s ${cssMap} css-map.json
         touch prefs

         # replace the spotify path with the current derivation's path
         sed "s|__REPLACEME__|${spotifyPath}|g; s|__REPLACEME2__|$SPICETIFY_CONFIG/prefs|g" ${config-xpui} > config-xpui.ini

         mkdir -p {Themes,Extensions,CustomApps}

         cp -r ${themePath} Themes/${theme.name}
         chmod -R a+wr Themes
         ${
           lib.optionalString (theme ? additionalCss) ''
             cat << EOF >> Themes/${theme.name}/user.css
               ${"\n" + theme.additionalCss}
             EOF
           ''
         }

         # extra commands that the theme might need
        ${lib.optionalString (theme ? extraCommands && theme.extraCommands != null) theme.extraCommands}

         # copy extensions into Extensions folder
         ${extensionCommands}

         # copy custom apps into CustomApps folder
         ${customAppCommands}

         # completed app and extension installation
         # add a custom color scheme if necessary
         ${lib.optionalString usingCustomColorScheme ''
          cat << EOF > Themes/${theme.name}/color.ini
            ${lib.generators.toINI { } { custom = customColorScheme; }}
          EOF
        ''}

         # completed custom color scheme addition
         ${extraCommands}

         ./spicetify-cli --no-restart backup apply
      '';
  }
)
