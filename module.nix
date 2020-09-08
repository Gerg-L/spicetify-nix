{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.programs.spicetify;
in {
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
      default = {};
    };
    thirdParyExtensions = mkOption {
      type = types.attrs;
      default = {};
    };
    thirdParyCustomApps = mkOption {
      type = types.attrs;
      default = {};
    };
    enabledExtensions = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    enabledCustomApps = mkOption {
      type = types.listOf types.str;
      default = [];
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
    home.packages = [
      (pkgs.callPackage ./package.nix {
        inherit pkgs;
        inherit (cfg) 
          theme
          colorScheme
          thirdParyThemes
          thirdParyExtensions
          thirdParyCustomApps
          enabledExtensions
          enabledCustomApps
          spotifyLaunchFlags
          injectCss
          replaceColors
          overwriteAssets
          disableSentry
          disableUiLogging
          removeRtlRule
          exposeApis
          disableUpgradeCheck
          fastUserSwitching
          visualizationHighFramerate
          radio
          songPage
          experimentalFeatures
          home
          lyricAlwaysShow
          lyricForceNoSync
        ;
      })
    ];
  };
}