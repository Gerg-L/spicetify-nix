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
      default = "SpicetifyDefault";
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
        rev = "dd7a7e13e0dc7a717cc06bba9ea04ed29d70a30e";
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
    xdg.configFile."spicetify/config-xpui.ini".text =
      let

        # turn certain values on by default if we know the theme needs it
        isDribblish = cfg.theme == "Dribblish";
        isTurntable = cfg.theme == "Turntable";
        injectCSSReal = boolToString (isDribblish || cfg.injectCss);
        replaceColorsReal = boolToString (isDribblish || cfg.replaceColors);
        overwriteAssetsReal = boolToString (isDribblish || cfg.overwriteAssets);


        pipeConcat = foldr (a: b: a + "|" + b) "";
        extensionString = pipeConcat (
          (if isDribblish then [ "dribbblish.js" ] else [ ])
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
                else if isString v then ''"${v}"''
                # and delegats all other values to the default generator
                else lib.generators.mkValueStringDefault { } v;
            } ":";
        };
      in
      customToINI {
        AdditionalOptions = {
          home = cfg.home;
          experimental_features = cfg.experimentalFeatures;
          extensions = extensionString;
          custom_apps = customAppsString;
          sidebar_config = 1; # i dont know what this does
        };
        Patch = { };
        Setting = {
          spotify_path = "${cfg.spotifyPackage}" /share/spotify;
          prefs_path = "${config.home.homeDirectory}/.config/spotify/prefs";
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
      };
    # install necessary packages for this user
    home.packages = with cfg;
      let
        inherit (pkgs.lib.lists) foldr;
        inherit (pkgs.lib.attrsets) mapAttrsToList;

        # Helper functions
        lineBreakConcat = foldr (a: b: a + "\n" + b) "";
        boolToString = x: if x then "1" else "0";
        makeLnCommands = type: (mapAttrsToList (name: path: "ln -sf ${path} ./${type}/${name}"));

        # Dribblish is a theme which needs a couple extra settings
        isDribblish = theme == "Dribbblish";
        isTurntable = theme == "Turntable";

        spicetify = "SPICETIFY_CONFIG=. ${cfg.spicetifyPackage}/bin/spicetify-cli";

        extraCommands =
          (if isDribblish then "cp ./Themes/Dribbblish/dribbblish.js ./Extensions \n" else "")
          + (if isTurntable then "cp ./Themes/Turntable/turntable.js ./Extensions \n" else "")
          + (lineBreakConcat (makeLnCommands "Themes" thirdParyThemes))
          + (lineBreakConcat (makeLnCommands "Extensions" thirdParyExtensions))
          + (lineBreakConcat (makeLnCommands "CustomApps" thirdParyCustomApps));

        customAppsFixupCommands = lineBreakConcat (makeLnCommands "Apps" thirdParyCustomApps);

        # custom spotify package with spicetify integrated in
        spiced-spotify-unwrapped = cfg.spotifyPackage.overrideAttrs (oldAttrs: rec {
          postInstall = ''
            touch $out/prefs
            mkdir Themes
            mkdir Extensions
            mkdir CustomApps
            
            # idk if this is neccessary, this whole script should be r/w right?
            ${pkgs.coreutils-full}/bin/chmod a+wr $out/share/spotify
            ${pkgs.coreutils-full}/bin/chmod a+wr $out/share/spotify/Apps

            find ${cfg.themesSrc} -maxdepth 1 -type d -exec ln -s {} Themes \;
            ${cfg.extraCommands}
            ${extraCommands}
    
            ${spicetify} backup apply

            cd $out/share/spotify
            ${customAppsFixupCommands}
          '';
        });
      in
      [
        spiced-spotify-unwrapped
        cfg.spicetifyPackage
      ];
  };
}

