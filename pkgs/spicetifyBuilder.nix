{
  lib,
  stdenv,
  writeText,
  crudini,
}:
lib.makeOverridable (
  {
    spotify,
    spicetify-cli,
    theme,
    config-xpui,
    customColorScheme,
    extensions,
    apps,
    extraCommands,
  }:

  spotify.overrideAttrs (old: {
    name = "spicetify-${theme.name}";
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ crudini ];

    postInstall =
      old.postInstall or ""
      + ''
        export SPICETIFY_CONFIG="$PWD"
        export SPICETIFY_STATE="$PWD/state"
        mkdir -p "SPICETIFY_STATE"

        mkdir -p {Themes,Extensions,CustomApps}

        cp -r '${theme.src}' 'Themes/${theme.name}'
        chmod -R a+wr 'Themes'

        ${lib.optionalString ((theme ? additionalCss) && theme.additionalCss != "") ''
          cat '${
            writeText "spicetify-additional-CSS" ("\n" + theme.additionalCss)
          }' >> 'Themes/${theme.name}/user.css'
        ''}

        # extra commands that this theme might need
        ${theme.extraCommands or ""}

        # copy extensions into Extensions folder
        ${lib.concatMapStringsSep "\n" (item: "cp -ru '${item.src}/${item.name}' 'Extensions'") extensions}

        # copy custom apps into CustomApps folder
        ${lib.concatMapStringsSep "\n" (item: "cp -ru '${item.src}' 'CustomApps/${item.name}'") apps}

        # add a custom color scheme if necessary
        ${lib.optionalString (customColorScheme != { }) ''
          cat '${
            writeText "spicetify-colors.ini" (lib.generators.toINI { } { custom = customColorScheme; })
          }' > 'Themes/${theme.name}/color.ini'
        ''}

        # verify that the color_scheme exists
        if ! crudini --get 'Themes/${theme.name}/color.ini' '${config-xpui.Setting.color_scheme}' &>/dev/null; then
          echo "colorScheme set to non-existent value: '${config-xpui.Setting.color_scheme}'"
          echo "Valid values:"
          crudini --get 'Themes/${theme.name}/color.ini'
          exit 1
        fi

        touch 'prefs'

        # replace the spotify path with the current derivation's path
        sed "s|__SPOTIFY__|${
          if stdenv.isLinux then
            "$out/share/spotify"
          else if stdenv.isDarwin then
            "$out/Applications/Spotify.app/Contents/Resources"
          else
            throw ""
        }|g; s|__PREFS__|$SPICETIFY_CONFIG/prefs|g" '${
          writeText "spicetify-confi-xpui" (lib.generators.toINI { } config-xpui)
        }' > 'config-xpui.ini'

        ${extraCommands}

        ${lib.getExe spicetify-cli} --no-restart backup apply
      '';
  })

)
