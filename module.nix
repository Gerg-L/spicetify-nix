{
  self,
  isNixOSModule ? false,
}:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.spicetify;
  spiceLib = self.lib;
  spicePkgs = self.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.programs.spicetify = {
    enable = lib.mkEnableOption "a modded Spotify";

    dontInstall = lib.mkEnableOption "outputting spiced spotify to config.programs.spicetify.spicedSpotify, but not installing it";

    spicedSpotify = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };

    createdPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      readOnly = true;
    };

    theme = lib.mkOption {
      type = spiceLib.types.theme;
      inherit (spicePkgs.themes) default;
    };

    spotifyPackage = lib.mkPackageOption pkgs "spotify" { };

    spotifywmPackage = lib.mkPackageOption pkgs "spotifywm" { };

    spicetifyPackage = lib.mkPackageOption pkgs "spicetify-cli" { };

    windowManagerPatch = lib.mkEnableOption "preloading the spotifywm patch";

    extraCommands = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra commands to be run during the setup of spicetify.";
    };

    enabledExtensions = lib.mkOption {
      type = lib.types.listOf spiceLib.types.extension;
      default = [ ];
      description = ''
        A list of extensions.
      '';
      example = ''
        [
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
    enabledCustomApps = lib.mkOption {
      type = lib.types.listOf spiceLib.types.app;
      default = [ ];
    };

    xpui = lib.mkOption {
      type = spiceLib.types.xpui;
      default = spiceLib.types.defaultXpui;
    };

    # legacy/ease of use options (commonly set for themes like Dribbblish)
    # injectCss = xpui.Setting.inject_css;
    injectCss = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };
    replaceColors = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = if (cfg.customColorScheme != null) then true else null;
    };
    overwriteAssets = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };
    sidebarConfig = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };
    colorScheme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = if cfg.customColorScheme != null then "custom" else null;
    };
    customColorScheme = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
    };

    cssMap = lib.mkOption { type = lib.types.path; };
  };

  config =
    let

      xpui = lib.attrsets.recursiveUpdate spiceLib.types.defaultXpui cfg.xpui;
      actualTheme = cfg.theme;

      # take the list of extensions and turn strings into actual extensions
      allExtensions =
        cfg.enabledExtensions
        ++ (lib.optionals (actualTheme ? requiredExtensions) actualTheme.requiredExtensions)
        ++ xpui.AdditionalOptions.extensions;

      # do the same thing again but for customapps this time
      allApps = cfg.enabledCustomApps ++ xpui.AdditionalOptions.custom_apps;

      # custom spotify package with spicetify integrated in
      spiced-spotify =
        let
          pre = spicePkgs.spicetify.override {
            spotify = cfg.spotifyPackage;
            spicetify-cli = cfg.spicetifyPackage;
            extensions = allExtensions;
            apps = allApps;
            theme = actualTheme;
            usingCustomColorScheme = cfg.customColorScheme != null;
            inherit (cfg) customColorScheme;
            # compose the configuration as well as options required by extensions and
            # cfg.xpui into one set
            config-xpui = spiceLib.xpuiBuilder {
              extensions = allExtensions;
              apps = allApps;
              theme = actualTheme;
              cfgXpui = xpui;
              cfgColorScheme = cfg.colorScheme;
              inherit cfg;
            };
          };
        in
        (
          assert lib.assertMsg (!(pkgs.stdenv.isDarwin && cfg.windowManagerPatch)) ''
            Spotifywm does not support darwin
          '';
          assert lib.assertMsg (cfg.spotifyPackage.pname != "spotifywm") ''
            Do not set spotifyPackage to pkgs.spotifywm
            instead enable windowManagerPatch and set spotifywmPackage
          '';

          if cfg.windowManagerPatch then cfg.spotifywmPackage.override { spotify = pre; } else pre
        );

      packagesToInstall =
        [ spiced-spotify ]
        ++
        # need montserrat for the BurntSienna theme
        (lib.optional (actualTheme == spicePkgs.themes.burntSienna) pkgs.montserrat)
        ++ (lib.optional (actualTheme == spicePkgs.themes.orchis) pkgs.fira);
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          programs.spicetify = {
            spicedSpotify = spiced-spotify;
            createdPackages = packagesToInstall;
          };
        }
        (lib.mkIf (!cfg.dontInstall) (
          if isNixOSModule then
            { environment.systemPackages = packagesToInstall; }
          else
            { home.packages = packagesToInstall; }
        ))
      ]
    );

  _file = ./module.nix;
}
