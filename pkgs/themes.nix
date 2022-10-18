{
  lib,
  source,
  ...
}:
with source; let
  # THEME GENERATORS ----------------------------------------------------------
  mkCatppuccinTheme = name: {
    ${name} = {
      inherit name;
      src = catppuccinSrc;
      appendName = true;
      requiredExtensions = [
        {
          src = "${catppuccinSrc}/js";
          filename = "${name}.js";
        }
      ];
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = false;
    };
  };
  mkComfyTheme = name: {
    ${name} = let
      lname = lib.strings.toLower name;
    in {
      inherit name;
      src = comfySrc;
      appendName = true;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = false;
      requiredExtensions = [
        {
          src = "${comfySrc}/${name}";
          filename = "${lname}.js";
        }
      ];
      extraCommands = ''
        # remove the auto-update functionality
        echo "\n" >> ./Extensions/${lname}.js
        cat ./Themes/${name}/${lname}.script.js >> ./Extensions/${lname}.js
      '';
    };
  };

  # THEMES --------------------------------------------------------------------

  SpotifyNoPremium = {
    name = "SpotifyNoPremium";
    src = spotifyNoPremiumSrc;
    appendName = false;
    requiredExtensions = [brokenAdblock]; # might also require charliesAdblock
    injectCss = false;
    replaceColors = false;
    overwriteAssets = false;
    sidebarConfig = false;
  };

  Fluent = {
    name = "Fluent";
    src = fluentSrc;
    appendName = false;
    injectCss = true;
    overwriteAssets = true;
    replaceColors = true;
    sidebarConfig = false;
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)32";
      "xpui.js_repl_8008" = ",$\{1}56";
    };
    requiredExtensions = [
      {
        src = fluentSrc;
        filename = "fluent.js";
      }
    ];
  };

  DefaultDynamic = {
    name = "DefaultDynamic";
    src = defaultDynamicSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = false;
    sidebarConfig = false;
    requiredExtensions = [
      {
        src = defaultDynamicSrc;
        filename = "default-dynamic.js";
      }
      {
        src = defaultDynamicSrc;
        filename = "Vibrant.min.js";
      }
    ];
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)32,";
      "xpui.js_repl_8008" = ",$\{1}28,";
    };
  };

  RetroBlur = {
    name = "RetroBlur";
    src = retroBlurSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = false;
    sidebarConfig = false;
  };

  # BROKEN. no clue why
  Omni = {
    name = "Omni";
    src = omniSrc;
    appendName = false;
    injectCss = true;
    overwriteAssets = true;
    replaceColors = true;
    sidebarConfig = false;
    requiredExtensions = [
      {
        src = omniSrc;
        filename = "omni.js";
      }
    ];
  };

  # light colorscheme is broken, think that's the theme's fault
  Bloom = {
    name = "Bloom";
    src = bloomSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;
    sidebarConfig = false;
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)32,";
      "xpui.js_repl_8008" = ",$\{1}56,";
    };
    requiredExtensions = [
      {
        src = bloomSrc;
        filename = "bloom.js";
      }
    ];
  };

  Orchis = {
    name = "DarkGreen";
    src = orchisSrc;
    appendName = true;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = false;
    sidebarConfig = false;
  };

  Dracula = {
    name = "Dracula";
    src = draculaSrc;
    appendName = true;
    replaceColors = true;
    injectCss = false;
    overwriteAssets = false;
    sidebarConfig = false;
  };

  Nord = {
    name = "Nord";
    src = nordSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = false;
    sidebarConfig = false;
  };

  # theres a thing at https://github.com/itsmeow/Spicetify-Canvas
  # about getting a custom build of chromium or something. I am NOT doing that
  # ... but maybe one day if someone asks
  # TODO: add the ability to append this user.css to any other user.css
  # for installation in any theme
  SpotifyCanvas = {
    name = "SpotifyCanvas";
    src = "${spotifyCanvasSrc}/Themes/canvas";
    appendName = false;
    injectCss = true;
    overwriteAssets = false;
    replaceColors = false;
    sidebarConfig = false;

    requiredExtensions = [
      {
        src = "${spotifyCanvasSrc}/Extensions";
        filename = "getCanvas.js";
      }
    ];
  };
in
  {
    official = let
      dribbblishExt = {
        filename = "dribbblish.js";
        src = "${officialThemes}/Dribbblish";
      };

      turntableExt = {
        filename = "turntable.js";
        src = "${officialThemes}/Turntable";
      };
      mkOfficialTheme = themeName: {
        ${themeName} = {
          name = themeName;
          src = officialThemes;
        };
      };
    in
      {
        Dribbblish = {
          name = "Dribbblish";
          src = officialThemes;
          requiredExtensions = [dribbblishExt];
          patches = {
            "xpui.js_find_8008" = ",(\\w+=)32";
            "xpui.js_repl_8008" = ",$\{1}56";
          };
          injectCss = true;
          replaceColors = true;
          overwriteAssets = true;
          appendName = true;
          sidebarConfig = true;
          additionalCss = ''
            .Root {
              padding-top: 0px;
            }
          '';
        };

        Dreary = {
          name = "Dreary";
          src = officialThemes;
          sidebarConfig = true;
          appendName = true;
        };
        Glaze = {
          name = "Glaze";
          src = officialThemes;
          sidebarConfig = true;
          appendName = true;
        };
        Turntable = {
          name = "Turntable";
          src = officialThemes;
          requiredExtensions = ["fullAppDisplay.js" turntableExt];
        };
      }
      // mkOfficialTheme "Ziro"
      // mkOfficialTheme "Sleek"
      // mkOfficialTheme "Onepunch"
      // mkOfficialTheme "Flow"
      // mkOfficialTheme "Default"
      // mkOfficialTheme "BurntSienna";
    inherit
      SpotifyNoPremium
      Fluent
      DefaultDynamic
      RetroBlur
      Omni
      Bloom
      Orchis
      Dracula
      Nord
      SpotifyCanvas
      ;
  }
  // mkCatppuccinTheme "catppuccin-mocha"
  // mkCatppuccinTheme "catppuccin-frappe"
  // mkCatppuccinTheme "catppuccin-latte"
  // mkCatppuccinTheme "catppuccin-macchiato"
  // mkComfyTheme "Comfy"
  // mkComfyTheme "Comfy-Chromatic"
  // mkComfyTheme "Comfy-Mono"
