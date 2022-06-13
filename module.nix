{ lib, pkgs, config, spicetify-themes, ... }:
with lib;
let
  cfg = config.programs.spicetify;
in
{
  options.programs.spicetify = {
    enable = mkEnableOption "A modded Spotify";
    theme = mkOption {
      type = types.str;
      default = "SpicetifyDefault";
    };
    colorScheme = mkOption {
      type = types.str;
      default = "";
    };
    thirdParyThemes = mkOption {
      type = types.attrs;
      default = { };
    };
    thirdParyExtensions = mkOption {
      type = types.attrs;
      default = { };
    };
    thirdParyCustomApps = mkOption {
      type = types.attrs;
      default = { };
    };
    enabledExtensions = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    enabledCustomApps = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    spotifyLaunchFlags = mkOption {
      type = types.str;
      default = "";
    };
    injectCss = mkOption {
      type = types.bool;
      default = false;
    };
    replaceColors = mkOption {
      type = types.bool;
      default = false;
    };
    overwriteAssets = mkOption {
      type = types.bool;
      default = false;
    };
    disableSentry = mkOption {
      type = types.bool;
      default = true;
    };
    disableUiLogging = mkOption {
      type = types.bool;
      default = true;
    };
    removeRtlRule = mkOption {
      type = types.bool;
      default = true;
    };
    exposeApis = mkOption {
      type = types.bool;
      default = true;
    };
    disableUpgradeCheck = mkOption {
      type = types.bool;
      default = true;
    };
    fastUserSwitching = mkOption {
      type = types.bool;
      default = false;
    };
    visualizationHighFramerate = mkOption {
      type = types.bool;
      default = false;
    };
    radio = mkOption {
      type = types.bool;
      default = false;
    };
    songPage = mkOption {
      type = types.bool;
      default = false;
    };
    experimentalFeatures = mkOption {
      type = types.bool;
      default = false;
    };
    home = mkOption {
      type = types.bool;
      default = false;
    };
    lyricAlwaysShow = mkOption {
      type = types.bool;
      default = false;
    };
    lyricForceNoSync = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # install necessary packages for this user
    home.packages =
      let
        inherit (pkgs.lib.lists) foldr;
        inherit (pkgs.lib.attrsets) mapAttrsToList;

        # Helper functions
        pipeConcat = foldr (a: b: a + "|" + b) "";
        lineBreakConcat = foldr (a: b: a + "\n" + b) "";
        boolToString = x: if x then "1" else "0";
        makeLnCommands = type: (mapAttrsToList (name: path: "ln -sf ${path} ./${type}/${name}"));
        # Setup spicetify and themes
        spicetify = "SPICETIFY_CONFIG=. ${pkgs.spicetify-cli}/spicetify";
        themes = spicetify-themes;

        # Dribblish is a theme which needs a couple extra settings
        isDribblish = theme == "Dribbblish";

        extraCommands = (if isDribblish then "cp ./Themes/Dribbblish/dribbblish.js ./Extensions \n" else "")
          + (lineBreakConcat (makeLnCommands "Themes" thirdParyThemes))
          + (lineBreakConcat (makeLnCommands "Extensions" thirdParyExtensions))
          + (lineBreakConcat (makeLnCommands "CustomApps" thirdParyCustomApps));

        customAppsFixupCommands = lineBreakConcat (makeLnCommands "Apps" thirdParyCustomApps);

        injectCssOrDribblish = boolToString (isDribblish || injectCss);
        replaceColorsOrDribblish = boolToString (isDribblish || replaceColors);
        overwriteAssetsOrDribblish = boolToString (isDribblish || overwriteAssets);

        extensionString = pipeConcat ((if isDribblish then [ "dribbblish.js" ] else [ ]) ++ enabledExtensions);
        customAppsString = pipeConcat enabledCustomApps;

        # custom spotify package with spicetify integrated in
        spiced-spotify-unwrapped = pkgs.spotify-unwrapped.overrideAttrs (oldAttrs: rec {
          postInstall = ''
            touch $out/prefs
            mkdir Themes
            mkdir Extensions
            mkdir CustomApps

            find ${themes} -maxdepth 1 -type d -exec ln -s {} Themes \;
            ${extraCommands}
    
            ${spicetify} config \
              spotify_path "$out/share/spotify" \
              prefs_path "$out/prefs" \
              current_theme ${theme} \
              ${if 
                  colorScheme != ""
                then 
                  ''color_scheme "${colorScheme}" \'' 
                else 
                  ''\'' }
              ${if 
                  extensionString != ""
                then 
                  ''extensions "${extensionString}" \'' 
                else 
                  ''\'' }
              ${if
                  customAppsString != ""
                then 
                  ''custom_apps "${customAppsString}" \'' 
                else 
                  ''\'' }
              ${if
                  spotifyLaunchFlags != ""
                then 
                  ''spotify_launch_flags "${spotifyLaunchFlags}" \'' 
                else 
                  ''\'' }
              inject_css ${injectCssOrDribblish} \
              replace_colors ${replaceColorsOrDribblish} \
              overwrite_assets ${overwriteAssetsOrDribblish} \
              disable_sentry ${boolToString disableSentry } \
              disable_ui_logging ${boolToString disableUiLogging } \
              remove_rtl_rule ${boolToString removeRtlRule } \
              expose_apis ${boolToString exposeApis } \
              disable_upgrade_check ${boolToString disableUpgradeCheck } \
              fastUser_switching ${boolToString fastUserSwitching } \
              visualization_high_framerate ${boolToString visualizationHighFramerate } \
              radio ${boolToString radio } \
              song_page ${boolToString songPage } \
              experimental_features ${boolToString experimentalFeatures } \
              home ${boolToString home } \
              lyric_always_show ${boolToString lyricAlwaysShow } \
              lyric_force_no_sync ${boolToString lyricForceNoSync }

            ${spicetify} backup apply

            cd $out/share/spotify
            ${customAppsFixupCommands}
          '';
        });
      in
      [
        spiced-spotify-unwrapped
        pkgs.spicetify-cli
      ];
  };
}

