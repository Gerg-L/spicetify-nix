{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.spicetify;
in
{
  options.programs.spicetify = {
    enable = mkEnableOption "A modded Spotify";
    theme = mkOption {
      type = types.str;
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

    themesSrc = mkOption {
      type = types.package;
      default = builtins.fetchGit {
        url = "https://github.com/spicetify/spicetify-themes";
        rev = "5d3d42f913467f413be9b0159f5df5023adf89af";
        submodules = true;
      };
      description = "A package which contains, at its root, a Themes directory,
        which should be copied into the spicetify themes directory.";
    };

    extraCommands = mkOption {
      type = types.lines;
      default = "";
      description = "Extra commands to be run during the setup of spicetify.";
    };

    colorScheme = mkOption {
      type = types.str;
      default = "";
    };
    thirdPartyThemes = mkOption {
      type = types.attrs;
      default = { };
      description = "A set of themes, indexed by name and containing the path to the theme.";
      example = ''
        {
          Dribbblish = $\{spicetify-themes-git}/Dribbblish;
        }
      '';
    };
    thirdPartyExtensions = mkOption {
      type = types.attrs;
      default = { };
    };
    thirdPartyCustomApps = mkOption {
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
    home.packages = with cfg;
      let
        # turn certain values on by default if we know the theme needs it
        isDribbblish = cfg.theme == "Dribbblish";
        isTurntable = cfg.theme == "Turntable";
        injectCSSReal = boolToString (isDribbblish || cfg.injectCss);
        replaceColorsReal = boolToString (isDribbblish || cfg.replaceColors);
        overwriteAssetsReal = boolToString (isDribbblish || cfg.overwriteAssets);


        pipeConcat = foldr (a: b: a + "|" + b) "";
        extensionString = pipeConcat (
          (if isDribbblish then [ "dribbblish.js" ] else [ ])
          ++ (if isTurntable then [ "turntable.js" ] else [ ])
          ++ cfg.enabledExtensions
        );
        customAppsString = pipeConcat cfg.enabledCustomApps;

        customToINI = lib.generators.toINI {
          # specifies how to format a key/value pair
          mkKeyValue = lib.generators.mkKeyValueDefault
            {
              # specifies the generated string for a subset of nix values
              mkValueString = v:
                if v == true then "1"
                else if v == false then "0"
                # else if isString v then ''"${v}"''
                # and delegats all other values to the default generator
                else lib.generators.mkValueStringDefault { } v;
            } "=";
        };

        config-xpui = builtins.toFile "config-xpui.ini" (customToINI {
          AdditionalOptions = {
            home = cfg.home;
            experimental_features = cfg.experimentalFeatures;
            extensions = extensionString;
            custom_apps = customAppsString;
            sidebar_config = 1; # i dont know what this does
          };
          Patch = { };
          Setting = {
            spotify_path = "__REPLACEME__"; # to be replaced in the spotify postInstall
            prefs_path = "__REPLACEME2__";
            current_theme = cfg.theme;
            color_scheme = cfg.colorScheme;
            spotify_launch_flags = cfg.spotifyLaunchFlags;
            check_spicetify_upgrade = 0;
            inject_css = injectCSSReal;
            replace_colors = replaceColorsReal;
            overwrite_assets = overwriteAssetsReal;
          };
          Preprocesses = {
            disable_upgrade_check = cfg.disableUpgradeCheck;
            disable_sentry = cfg.disableSentry;
            disable_ui_logging = cfg.disableUiLogging;
            remove_rtl_rule = cfg.removeRtlRule;
            expose_apis = cfg.exposeApis;
          };
          Backup = {
            version = cfg.spotifyPackage.version;
            "with" = "Dev";
          };
        });

        # INI created, now create the postInstall that runs spicetify
        inherit (pkgs.lib.lists) foldr;
        inherit (pkgs.lib.attrsets) mapAttrsToList;

        # Helper functions
        lineBreakConcat = foldr (a: b: a + "\n" + b) "";
        boolToString = x: if x then "1" else "0";
        makeCpCommands = type: (mapAttrsToList (name: path: "cp -r ${path} ./${type}/${name} && ${pkgs.coreutils-full}/bin/chmod -R a+wr ./${type}/${name}"));

        spicetify = "${cfg.spicetifyPackage}/bin/spicetify-cli --no-restart";

        # custom spotify package with spicetify integrated in
        spiced-spotify = cfg.spotifyPackage.overrideAttrs (oldAttrs: rec {
          postInstall = ''
            export SPICETIFY_CONFIG=$out/spicetify
            mkdir -p $SPICETIFY_CONFIG
            pushd $SPICETIFY_CONFIG
                
            # create config and prefs
            cp ${config-xpui} config-xpui.ini
            ${pkgs.coreutils-full}/bin/chmod a+wr config-xpui.ini
            touch $out/share/spotify/prefs
                
            # replace the spotify path with the current derivation's path
            sed -i "s|__REPLACEME__|$out/share/spotify|g" config-xpui.ini
            sed -i "s|__REPLACEME2__|$out/share/spotify/prefs|g" config-xpui.ini

            cp -r ${cfg.themesSrc} Themes
            ${pkgs.coreutils-full}/bin/chmod -R a+wr Themes

            # the following command will link themes, but we want to copy so we can have w/r
            # find ${cfg.themesSrc} -maxdepth 1 -type d -exec ln -s {} Themes \;
            ${cfg.extraCommands}
            ${if isDribbblish then "cp ./Themes/Dribbblish/dribbblish.js ./Extensions \n" else ""}
            ${if isTurntable then "cp ./Themes/Turntable/turntable.js ./Extensions \n" else ""}
            # copy themes into Themes folder
            ${lineBreakConcat (makeCpCommands "Themes" cfg.thirdPartyThemes)}
            # copy extensions into Extensions folder
            ${lineBreakConcat (makeCpCommands "Extensions" cfg.thirdPartyExtensions)}
            # copy custom apps into CustomApps folder
            ${lineBreakConcat (makeCpCommands "CustomApps" cfg.thirdPartyCustomApps)}
                
            popd

            pushd $out/share/spotify
            ${lineBreakConcat (makeCpCommands "Apps" thirdPartyCustomApps)}
            popd
            
            ${spicetify} backup apply
            
            # fix config to point to home directory (not necessary I don't think, but whatever)
            # sed -i "s|$out/share/spotify/prefs|${config.home.homeDirectory}/.config/spotify/prefs|g" $SPICETIFY_CONFIG/config-xpui.ini
          '';
        });
      in
      [
        spiced-spotify
        cfg.spicetifyPackage
      ];
  };
}

