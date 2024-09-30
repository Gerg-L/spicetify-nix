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
  spicePkgs = self.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  extensionType = lib.types.either lib.types.pathInStore (
    lib.types.submodule {
      freeformType = lib.types.attrs;
      options = {
        src = lib.mkOption {
          type = lib.types.pathInStore;
          description = "Path to the folder which contains the .js file.";
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name of the .js file to enable.";
          example = "dribbblish.js";
        };
        experimentalFeatures = lib.mkEnableOption "experimental_features in config-xpui.ini";
      };
    }
  );
in
{
  options.programs.spicetify = {
    enable = lib.mkEnableOption "Spicetify a modified Spotify.";

    dontInstall = lib.mkEnableOption "outputting spiced spotify to config.programs.spicetify.spicedSpotify, but not installing it.";

    spicedSpotify = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };

    createdPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      readOnly = true;
    };

    theme = lib.mkOption {
      inherit (spicePkgs.themes) default;

      type = lib.types.submodule {
        freeformType = lib.types.attrs;
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "The name of the theme as it will be copied into the spicetify themes directory.";
            example = "Dribbblish";
          };

          src = lib.mkOption {

            type = lib.types.pathInStore;
            description = "Path to folder containing the theme.";
            example = ''
              fetchFromGitHub {
                owner = "spicetify";
                repo = "spicetify-themes";
                rev = "02badb180c902f986a4ea4e4033e69fe8eec6a55";
                hash = "sha256-KD9VfHtlN0BIHC4inlooxw5XC4xlHNC5evASRqP7pUA=";
              }
              Or a relative path 

              ./myTheme
            '';
          };
          requiredExtensions = lib.mkOption {
            type = lib.types.listOf extensionType;
            default = [ ];
          };

          patches = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            example = ''
              {
                "xpui.js_find_8008" = ",(\\w+=)32";
                "xpui.js_repl_8008" = ",$\{1}56";
              };
            '';
            description = "INI entries to add in the [Patch] section of config-xpui.ini";
            default = { };
          };

          extraCommands = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "A bash script to run from the spicetify config directory if this theme is installed.";
          };

          extraPkgs = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Extra required packges for the theme to function (usually a font)";
          };

          # some config values that can be specified per-theme
          injectCss = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          injectThemeJs = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          replaceColors = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          homeConfig = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          overwriteAssets = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          additionalCss = lib.mkOption {
            type = lib.types.lines;
            default = "";
          };
        };
      };
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
      type = lib.types.listOf extensionType;
      default = [ ];
      description = ''
        A list of extensions.
      '';
      example = ''
        [
          {
            src = (pkgs.fetchFromGitHub {
              owner = "Taeko-ar";
              repo = "spicetify-last-fm";
              rev = "d2f1d3c1e286d789ddfa002f162405782d822c55";
              hash = "sha256-/C4Y3zuSAEwhMXCRG2/4b5oWfGz/ij6wu0B+CpuJKXs=";
            }) + /src;

            name = "lastfm.js";
          }
        ]
      '';
    };
    enabledCustomApps = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          freeformType = lib.types.attrs;
          options = {
            src = lib.mkOption {
              type = lib.types.pathInStore;
              description = "Path to the folder containing the app code.";
              example = ''
                pkgs.fetchFromGitHub {
                  owner = "hroland";
                  repo = "spicetify-show-local-files";
                  rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
                  hash = "sha256-neKR2WaZ1K10dZZ0nAKJJEHNS56o8vCpYpi+ZJYJ/gU=";
                }
              '';
            };
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the app. No spaces or special characters";
              example = "localFiles";
              default = "";
            };
          };
        }
      );
      default = [ ];
    };

    colorScheme = lib.mkOption {
      type = lib.types.str;
      default = if cfg.customColorScheme == { } then "" else "custom";
    };
    customColorScheme = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
    enabledSnippets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    spotifyLaunchFlags = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    alwaysEnableDevTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    updateXpuiPredicate = lib.mkOption {
      type = lib.types.either (lib.types.attrsOf lib.types.str) (
        lib.types.functionTo (lib.types.attrsOf lib.types.str)
      );
      default = { };
    };
  };

  config =
    let

      # take the list of extensions and turn strings into actual extensions
      allExtensions = cfg.enabledExtensions ++ cfg.theme.requiredExtensions;

      # custom spotify package with spicetify integrated in
      spiced-spotify =
        let
          xpui =
            let
              xpui_ = {

                AdditionalOptions = {
                  extensions = lib.concatMapStringsSep "|" (item: item.name) allExtensions;
                  custom_apps = lib.concatMapStringsSep "|" (item: item.name) cfg.enabledCustomApps;
                  # must be disabled on newer spotify
                  sidebar_config = false;

                  home_config = cfg.theme.homeConfig;

                  experimental_features = lib.any (item: (item.experimentalFeatures or false)) allExtensions;
                };

                Setting = {
                  spotify_path = "__SPOTIFY__";
                  prefs_path = "__PREFS__";
                  inject_theme_js = cfg.theme.injectThemeJs;
                  replace_colors = cfg.theme.replaceColors;
                  check_spicetify_update = false;
                  current_theme = cfg.theme.name;
                  color_scheme = cfg.colorScheme;
                  inject_css = cfg.theme.injectCss;
                  overwrite_assets = cfg.theme.overwriteAssets;
                  spotify_launch_flags = cfg.spotifyLaunchFlags;
                  always_enable_devtools = cfg.alwaysEnableDevTools;
                };

                Patch = cfg.theme.patches or { };

                Preprocesses = {
                  disable_ui_logging = true;
                  remove_rtl_rule = true;
                  expose_apis = true;
                  disable_sentry = true;
                };

                Backup = {
                  inherit (cfg.spotifyPackage) version;
                  "with" = cfg.spicetifyPackage.version;
                };
              };
            in
            if (lib.isFunction cfg.updateXpuiPredicate) then
              cfg.updateXpuiPredicate xpui_
            else if (lib.isAttrs cfg.updateXpuiPredicate && cfg.updateXpuiPredicate != { }) then
              cfg.updateXpuiPredicate
            else
              xpui_;

          pre = spicePkgs.spicetifyBuilder {
            spotify = cfg.spotifyPackage;
            spicetify-cli = cfg.spicetifyPackage;
            extensions = allExtensions;
            apps = cfg.enabledCustomApps;
            theme = cfg.theme // {
              additionalCss = lib.concatLines ([ (cfg.theme.additionalCss or "") ] ++ cfg.enabledSnippets);
            };
            inherit (cfg) customColorScheme extraCommands;
            # compose the configuration as well as options required by extensions and
            # cfg.cfg.xpui into one set
            config-xpui = xpui;
          };
        in

        assert lib.assertMsg (!(pkgs.stdenv.isDarwin && cfg.windowManagerPatch)) ''
          Spotifywm does not support darwin
        '';
        assert lib.assertMsg (cfg.spotifyPackage.pname != "spotifywm") ''
          Do not set spotifyPackage to pkgs.spotifywm
          instead enable windowManagerPatch and set spotifywmPackage
        '';

        if cfg.windowManagerPatch then
          (cfg.spotifywmPackage.override { spotify = pre; }).overrideAttrs (old: {
            passthru = (old.passthru or { }) // pre.passthru;
          })
        else
          pre;
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          programs.spicetify = {
            spicedSpotify = spiced-spotify;
            createdPackages = [ spiced-spotify ] ++ cfg.theme.extraPkgs;
          };
        }
        (lib.mkIf (!cfg.dontInstall) (
          if isNixOSModule then
            { environment.systemPackages = cfg.createdPackages; }
          else
            { home.packages = cfg.createdPackages; }
        ))
      ]
    );

  _file = ./module.nix;
}
