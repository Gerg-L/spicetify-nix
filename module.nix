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
  spiceLib = self.lib.${pkgs.stdenv.hostPlatform.system};
  spicePkgs = self.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.programs.spicetify = {
    enable = lib.mkEnableOption "A modded Spotify";

    dontInstall = lib.mkEnableOption "Put spiced spotify in config.programs.spicetify.spicedSpotify, but do not install it in home.packages.";

    windowManagerPatch = lib.mkEnableOption "Linker preload spotifywm patch.";

    spicedSpotify = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };
    createdPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      readOnly = true;
    };

    theme = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.str
        spiceLib.types.theme
      ];
      default = spicePkgs.themes.Default;
    };

    spotifyPackage = lib.mkPackageOption pkgs "spotify" { };

    spicetifyPackage = lib.mkPackageOption pkgs "spicetify-cli" { };

    extraCommands = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra commands to be run during the setup of spicetify.";
    };

    enabledExtensions = lib.mkOption {
      type = lib.types.listOf (
        lib.types.oneOf [
          spiceLib.types.extension
          lib.types.str
        ]
      );
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
      type = lib.types.listOf (
        lib.types.oneOf [
          spiceLib.types.app
          lib.types.str
        ]
      );
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

    cssMap = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.spicetifyPackage.src}/css-map.json";
    };
  };

  config =
    let

      isSpotifyWM = cfg.spotifyPackage.pname == "spotifywm";

      xpui = lib.attrsets.recursiveUpdate cfg.xpui spiceLib.types.defaultXpui;
      actualTheme = cfg.theme;

      # take the list of extensions and turn strings into actual extensions
      allExtensions =
        cfg.enabledExtensions
        ++ (lib.optionals (builtins.hasAttr "requiredExtensions" actualTheme)
          actualTheme.requiredExtensions
        )
        ++ xpui.AdditionalOptions.extensions;

      # do the same thing again but for customapps this time
      allApps = cfg.enabledCustomApps ++ xpui.AdditionalOptions.custom_apps;

      # custom spotify package with spicetify integrated in
      spiced-spotify =
        let

          overridenSpotify = spiceLib.spicetifyBuilder {
            spotify = cfg.spotifyPackage;
            spicetify = cfg.spicetifyPackage;
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
        if isSpotifyWM then
          cfg.spotifyPackage.override { spotify = overridenSpotify; }
        else
          overridenSpotify;

      packagesToInstall =
        [
          (
            # give warning if spotifywm is set redundantly
            if isSpotifyWM && cfg.windowManagerPatch then
              lib.trivial.warn "spotify package set to spotifywm and windowManagerPatch is set to true. It is recommended to only use windowManagerPatch."
            # wrap spotify with the window manager patch if necessary
            else if cfg.windowManagerPatch then
              spicePkgs.spotifywm.override { spotify = spiced-spotify; }
            else
              spiced-spotify
          )
        ]
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
        (
          if isNixOSModule then
            { environment.systemPackages = lib.optionals (!cfg.dontInstall) packagesToInstall; }
          else
            { home.packages = lib.optionals (!cfg.dontInstall) packagesToInstall; }
        )
      ]
    );
}
