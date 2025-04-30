self:
{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  spicePkgs = self.packages or self.legacyPackages.${pkgs.stdenv.system};

  extensionType = lib.types.either lib.types.pathInStore (
    lib.types.submodule {
      freeformType = lib.types.attrsOf lib.types.anything;
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
  imports = [
    (pkgs.path + "/nixos/modules/misc/assertions.nix")

    (lib.mkRemovedOptionModule [ "dontInstall" ] ''
      set 'enable = false;' instead.
    '')
  ];

  options = {
    enable = lib.mkEnableOption "Spicetify a modified Spotify.";

    spicedSpotify = lib.mkOption {
      type = lib.types.package;
      description = "The final spotify package after spicing.";
      readOnly = true;
    };

    createdPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = ''
        A list of all generated packages containing the spiced spotify and extra packages from the current theme.
      '';
      default = [ config.spicedSpotify ] ++ config.theme.extraPkgs;
      defaultText = lib.literalExpression ''
        [ spicedSpotify ] ++ theme.extraPkgs
      '';
      readOnly = true;
    };

    theme = lib.mkOption {
      description = "";
      inherit (spicePkgs.themes) default;

      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.anything;
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
            description = "";
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
            description = "";
            type = lib.types.bool;
            default = true;
          };
          injectThemeJs = lib.mkOption {

            description = "";
            type = lib.types.bool;
            default = true;
          };
          replaceColors = lib.mkOption {
            description = "";
            type = lib.types.bool;
            default = true;
          };
          homeConfig = lib.mkOption {
            description = "";
            type = lib.types.bool;
            default = true;
          };
          overwriteAssets = lib.mkOption {
            description = "";
            type = lib.types.bool;
            default = false;
          };
          additionalCss = lib.mkOption {
            description = "";
            type = lib.types.lines;
            default = "";
          };
        };
      };
    };

    spotifyPackage = lib.mkPackageOption pkgs "spotify" { };

    spicetifyPackage = lib.mkPackageOption pkgs "spicetify-cli" { };

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
        See https://spicetify.app/docs/advanced-usage/extensions/.
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
      description = ''
        Custom apps to add to the spice.
        See https://spicetify.app/docs/development/custom-apps.
      '';
      type = lib.types.listOf (
        lib.types.submodule {
          freeformType = lib.types.attrsOf lib.types.anything;
          options = {
            src = lib.mkOption {
              type = lib.types.pathInStore;
              description = "Path to the folder containing the app code.";
              example = lib.literalExpression ''
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
      description = ''
        Spicetify color scheme to use, given a specific `theme`.
        If using `customColorScheme`, leave this as default `"custom"`.
      '';
      default = if config.customColorScheme != { } then "custom" else "";
    };
    customColorScheme = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = ''
        Custom scheme used to generate a corresponding `color.ini`.
        See https://spicetify.app/docs/development/themes.
      '';
      default = { };
    };
    enabledSnippets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        Snippets to add to the spice.
        See https://github.com/spicetify/marketplace/blob/main/resources/snippets.json.
      '';
      default = [ ];
    };

    spotifyLaunchFlags = lib.mkOption {
      type = lib.types.str;
      description = "Launch flags to pass to spotify.";
      default = "";
    };

    experimentalFeatures = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      example = true;
      description = ''
        Whether to enable experimental features.
      '';
    };

    alwaysEnableDevTools = lib.mkEnableOption "chromium dev tools";

    # If you have to use this you should probably make a PR instead
    updateXpui = lib.mkOption {
      type = lib.types.either (lib.types.attrsOf lib.types.str) (
        lib.types.functionTo (lib.types.attrsOf lib.types.str)
      );
      default = { };
      internal = true;
    };
  };

  config =
    let
      # take the list of extensions and turn strings into actual extensions
      allExtensions = config.enabledExtensions ++ config.theme.requiredExtensions;

      xpui =
        let
          xpui_ = {
            AdditionalOptions = {
              extensions = lib.concatMapStringsSep "|" (item: item.name) allExtensions;
              custom_apps = lib.concatMapStringsSep "|" (item: item.name) config.enabledCustomApps;
              # must be disabled on newer spotify
              sidebar_config = false;

              home_config = config.theme.homeConfig;

              experimental_features =
                if config.experimentalFeatures != null then
                  config.experimentalFeatures
                else
                  lib.any (item: (item.experimentalFeatures or false)) allExtensions;
            };

            Setting = {
              spotify_path = "__SPOTIFY__";
              prefs_path = "__PREFS__";
              inject_theme_js = config.theme.injectThemeJs;
              replace_colors = config.theme.replaceColors;
              check_spicetify_update = false;
              current_theme = config.theme.name;
              color_scheme = config.colorScheme;
              inject_css = config.theme.injectCss;
              overwrite_assets = config.theme.overwriteAssets;
              spotify_launch_flags = config.spotifyLaunchFlags;
              always_enable_devtools = config.alwaysEnableDevTools;
            };

            Patch = config.theme.patches or { };

            Preprocesses = {
              disable_ui_logging = true;
              remove_rtl_rule = true;
              expose_apis = true;
              disable_sentry = true;
            };

            Backup = {
              inherit (config.spotifyPackage) version;
              "with" = "Dev";
            };
          };
        in
        if (lib.isFunction config.updateXpui) then
          config.updateXpui xpui_
        else if (lib.isAttrs config.updateXpui && config.updateXpui != { }) then
          config.updateXpui
        else
          xpui_;

    in

    {
      spicedSpotify =
        let
          spicedSpotify' = spicePkgs.spicetifyBuilder {
            spotify = config.spotifyPackage;
            spicetify-cli = config.spicetifyPackage;
            extensions = allExtensions;
            apps = config.enabledCustomApps;
            theme = config.theme // {
              additionalCss = lib.concatLines ([ (config.theme.additionalCss or "") ] ++ config.enabledSnippets);
            };
            inherit (config) customColorScheme extraCommands colorScheme;
            # compose the configuration as well as options required by extensions and
            # config.config.xpui into one set
            config-xpui = xpui;
            wayland = if pkgs.stdenv.isLinux then config.wayland else null;
          };
        in
        if pkgs.stdenv.isLinux && config.windowManagerPatch then
          (config.spotifywmPackage.override { spotify = spicedSpotify'; }).overrideAttrs (old: {
            passthru = (old.passthru or { }) // spicedSpotify'.passthru;
          })
        else
          spicedSpotify';

    };
  _file = ./common.nix;
}
