{lib, ...}: let
  inherit (lib) mkOption types mkEnableOption;

  defaultXpui = {
    AdditionalOptions = {
      home = false;
      experimental_features = false;
      extensions = [];
      custom_apps = [];
      sidebar_config = true;
    };
    Setting = {
      spotify_path = "__REPLACEME__";
      prefs_path = "__REPLACEME2__";
      current_theme = "";
      color_scheme = "";
      spotify_launch_flags = "";
      check_spicetify_upgrade = false;
      inject_css = false;
      replace_colors = false;
      overwrite_assets = false;
    };
    Preprocesses = {
      disable_upgrade_check = true;
      disable_sentry = true;
      disable_ui_logging = true;
      remove_rtl_rule = true;
      expose_apis = true;
    };
    Backup = {
      version = "";
      "with" = "Dev";
    };
    Patch = {};
  };

  xpui = types.submodule {
    options = {
      AdditionalOptions = mkOption {
        type = types.submodule {
          options = {
            home = mkOption {
              type = types.bool;
              default = defaultXpui.AdditionalOptions.home;
            };
            experimental_features = mkOption {
              type = types.bool;
              default = defaultXpui.AdditionalOptions.experimental_features;
            };
            extensions = mkOption {
              type = types.listOf types.str;
              default = defaultXpui.AdditionalOptions.extensions;
            };
            custom_apps = mkOption {
              type = types.listOf types.str;
              default = defaultXpui.AdditionalOptions.custom_apps;
            };
            sidebar_config = mkOption {
              type = types.bool;
              default = defaultXpui.AdditionalOptions.sidebar_config;
            };
          };
        };
        default = defaultXpui.AdditionalOptions;
      };
      Patch = {};
      Setting = mkOption {
        type = types.submodule {
          options = {
            spotify_path = mkOption {
              type = types.str;
              default = defaultXpui.Setting.spotify_path;
            };
            prefs_path = mkOption {
              type = types.str;
              default = defaultXpui.Setting.prefs_path;
            };
            current_theme = mkOption {
              type = types.str;
              default = defaultXpui.Setting.current_theme;
            };
            color_scheme = mkOption {
              type = types.str;
              default = defaultXpui.Setting.color_scheme;
            };
            spotify_launch_flags = mkOption {
              type = types.str;
              default = defaultXpui.Setting.spotify_launch_flags;
            };
            check_spicetify_upgrade = mkOption {
              type = types.bool;
              default = defaultXpui.Setting.check_spicetify_upgrade;
            };
            inject_css = mkOption {
              type = types.bool;
              default = defaultXpui.Setting.inject_css;
            };
            replace_colors = mkOption {
              type = types.bool;
              default = defaultXpui.Setting.replace_colors;
            };
            overwrite_assets = mkOption {
              type = types.bool;
              default = defaultXpui.Setting.overwrite_assets;
            };
          };
        };
        default = defaultXpui.Setting;
      };
      Preprocesses = mkOption {
        type = types.submodule {
          options = {
            disable_upgrade_check = mkOption {
              type = types.bool;
              default = defaultXpui.Preprocesses.disable_upgrade_check;
            };
            disable_sentry = mkOption {
              type = types.bool;
              default = defaultXpui.Preprocesses.disable_sentry;
            };
            disable_ui_logging = mkOption {
              type = types.bool;
              default = defaultXpui.Preprocesses.disable_ui_logging;
            };
            remove_rtl_rule = mkOption {
              type = types.bool;
              default = defaultXpui.Preprocesses.remove_rtl_rule;
            };
            expose_apis = mkOption {
              type = types.bool;
              default = defaultXpui.Preprocesses.expose_apis;
            };
          };
        };
        default = defaultXpui.Preprocesses;
      };
      Backup = mkOption {
        type = types.submodule {
          options = {
            version = mkOption {
              type = types.str;
              default = defaultXpui.Backup.version;
            };
            "with" = mkOption {
              type = types.str;
              default = defaultXpui.Backup."with";
            };
          };
        };
        default = {};
      };
    };
  };

  extension = types.submodule {
    options = {
      src = mkOption {
        type = types.oneOf [types.path types.str];
        description = "Path to the folder which contains the .js file.";
      };
      filename = mkOption {
        type = types.str;
        description = "Name of the .js file to enable.";
        example = "dribbblish.js";
      };
      experimentalFeatures = mkEnableOption "Value to set AdditionalOptions/experimental_features to.";
    };
  };

  theme = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the theme as it will be copied into the spicetify themes directory.";
        example = ''Dribbblish'';
      };
      src = mkOption {
        type = types.oneOf [types.path types.str];
        description = "Path to folder containing the theme.";
        example = ''          pkgs.fetchgit {
                                url = "https://github.com/spicetify/spicetify-themes";
                                rev = "5d3d42f913467f413be9b0159f5df5023adf89af";
                                submodules = true;
                              };'';
      };
      requiredExtensions = mkOption {
        type = types.listOf (types.oneOf [extension types.str]);
        default = [];
      };

      appendName = mkOption {
        type = types.bool;
        default = true;
        description = ''          Whether or not to append the name of the theme
                  to the src file path when copying. For example:
                  (with appendName on)
                  cp /nix/store/2309435394589320fjirjf032-spicetify-themes/Dribbblish Themes
                  (with appendName off)
                  cp /nix/store/2309435394589320fjirjf032-spicetify-themes Themes
        '';
      };

      patches = mkOption {
        type = types.attrs;
        example = ''
          {
              "xpui.js_find_8008" = ",(\\w+=)32";
              "xpui.js_repl_8008" = ",$\{1}56";
          };
        '';
        description = "INI entries to add in the [Patch] section of config-xpui.ini";
        default = {};
      };

      extraCommands = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = "A bash script to run from the spicetify config directory if this theme is installed.";
      };

      # some config values that can be specified per-theme
      injectCss = mkOption {
        type = types.nullOr types.bool;
      };
      overwriteAssets = mkOption {
        type = types.nullOr types.bool;
      };
      replaceColors = mkOption {
        type = types.nullOr types.bool;
      };
      sidebarConfig = mkOption {
        type = types.nullOr types.bool;
      };
      additionalCss = mkOption {
        type = types.lines;
        default = '''';
      };
    };
  };

  app = types.submodule {
    options = {
      src = mkOption {
        type = types.oneOf [types.path types.str];
        description = "Path to the folder containing the app code.";
        example = ''
          pkgs.fetchgit {
            url = "https://github.com/hroland/spicetify-show-local-files/";
            rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
            sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
          };
        '';
      };
      name = mkOption {
        type = types.nullOr types.str;
        description = "Name of the app. No spaces or special characters please :)";
      };
      appendName = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
in {
  inherit theme extension xpui app defaultXpui;
}
