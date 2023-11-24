{ source, lib }:
(lib.genAttrs
  [
    "blossom"
    "burntSienna"
    "default"
    "flow"
    "matte"
    "nightlight"
    "onepunch"
    "sleek"
    "ziro"
  ]
  (
    x: {
      name = lib.toUpper (builtins.substring 0 1 x) + (builtins.substring 1 (builtins.stringLength x) x);
      src = source.officialThemes;
      appendName = true;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;
    }
  )
)
//

  {
    catppuccin = {
      name = "catppuccin";
      src = source.catppuccinSrc;
      appendName = true;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = false;
    };
    dribbblish = {
      name = "Dribbblish";
      src = source.officialThemes;
      requiredExtensions = [
        {
          filename = "dribbblish.js";
          src = "${source.officialThemes}/Dribbblish";
        }
      ];
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32";
        "xpui.js_repl_8008" = ",\${1}56";
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

    text = {
      name = "text";
      src = source.officialThemes;
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)56";
        "xpui.js_repl_8008" = ",\${1}32";
      };
      injectCss = true;
      replaceColors = true;
      appendName = true;
      overwriteAssets = false;
      sidebarConfig = false;
    };

    dreary = {
      name = "Dreary";
      src = source.officialThemes;
      sidebarConfig = true;
      appendName = true;
    };
    glaze = {
      name = "Glaze";
      src = source.officialThemes;
      sidebarConfig = true;
      appendName = true;
    };
    turntable = {
      name = "Turntable";
      src = source.officialThemes;
      requiredExtensions =
        [
          #"fullAppDisplay.js"
          {
            filename = "turntable.js";
            src = "${source.officialThemes}/Turntable";
          }
        ];
    };

    spotifyNoPremium = {
      name = "SpotifyNoPremium";
      src = source.spotifyNoPremiumSrc;
      appendName = false;
      requiredExtensions = [
        {
          src = "${source.charlieS1103Src}/adblock";
          filename = "adblock.js";
        }
      ];
      injectCss = false;
      replaceColors = false;
      overwriteAssets = false;
      sidebarConfig = false;
    };

    fluent = {
      name = "Fluent";
      src = source.fluentSrc;
      appendName = false;
      injectCss = true;
      overwriteAssets = true;
      replaceColors = true;
      sidebarConfig = false;
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32";
        "xpui.js_repl_8008" = ",\${1}56";
      };
      requiredExtensions = [
        {
          src = source.fluentSrc;
          filename = "fluent.js";
        }
      ];
    };

    defaultDynamic = {
      name = "DefaultDynamic";
      src = source.defaultDynamicSrc;
      appendName = false;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;
      requiredExtensions = [
        {
          src = source.defaultDynamicSrc;
          filename = "default-dynamic.js";
        }
        {
          src = source.defaultDynamicSrc;
          filename = "Vibrant.min.js";
        }
      ];
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32,";
        "xpui.js_repl_8008" = ",\${1}28,";
      };
    };

    retroBlur = {
      name = "RetroBlur";
      src = source.retroBlurSrc;
      appendName = false;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;
    };

    # BROKEN. no clue why
    omni = {
      name = "Omni";
      src = source.omniSrc;
      appendName = false;
      injectCss = true;
      overwriteAssets = true;
      replaceColors = true;
      sidebarConfig = false;
      requiredExtensions = [
        {
          src = source.omniSrc;
          filename = "omni.js";
        }
      ];
    };

    # light colorscheme is broken, think that's the theme's fault
    bloom = {
      name = "Bloom";
      src = source.bloomSrc;
      appendName = false;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = false;
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32,";
        "xpui.js_repl_8008" = ",\${1}56,";
      };
      requiredExtensions = [
        {
          src = source.bloomSrc;
          filename = "bloom.js";
        }
      ];
    };

    orchis = {
      name = "DarkGreen";
      src = source.orchisSrc;
      appendName = true;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;
    };

    dracula = {
      name = "Dracula";
      src = source.draculaSrc;
      appendName = true;
      replaceColors = true;
      injectCss = false;
      overwriteAssets = false;
      sidebarConfig = false;
    };

    nord = {
      name = "Nord";
      src = source.nordSrc;
      appendName = true;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = false;
      sidebarConfig = false;
    };

    comfy = {
      name = "Comfy";
      src = source.comfySrc;
      appendName = true;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = false;
      requiredExtensions = [
        {
          src = "${source.comfySrc}/Comfy";
          filename = "theme.js";
        }
      ];
      extraCommands = ''
        # remove the auto-update functionality
        echo "\n" >> ./Extensions/theme.js
        cat ./Themes/Comfy/theme.script.js >> ./Extensions/theme.js
      '';
    };

    # theres a thing at https://github.com/itsmeow/Spicetify-Canvas
    # about getting a custom build of chromium or something. I am NOT doing that
    # ... but maybe one day if someone asks
    # TODO: add the ability to append this user.css to any other user.css
    # for installation in any theme
    spotifyCanvas = {
      name = "SpotifyCanvas";
      src = "${source.spotifyCanvasSrc}/Themes/canvas";
      appendName = false;
      injectCss = true;
      overwriteAssets = false;
      replaceColors = false;
      sidebarConfig = false;

      requiredExtensions = [
        {
          src = "${source.spotifyCanvasSrc}/Extensions";
          filename = "getCanvas.js";
        }
      ];
    };
  }
