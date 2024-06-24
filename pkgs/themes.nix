{
  sources,
  extensions,
  pkgs,
}:
let
  inherit (pkgs) lib;
in
(lib.genAttrs
  [
    "blossom"
    "default"
    "flow"
    "matte"
    "nightlight"
    "onepunch"
    "sleek"
    "starryNight"
    "ziro"
  ]
  (
    x:
    let

      name = lib.toUpper (builtins.substring 0 1 x) + (builtins.substring 1 (builtins.stringLength x) x);
    in
    {
      inherit name;
      src = "${sources.officialThemes}/${name}";

      sidebarConfig = false;
    }
  )
)
//

  {
    burntSienna = {
      name = "BurntSienna";
      src = "${sources.officialThemes}/BurntSienna";
      extraPkgs = [ pkgs.montserrat ];

      sidebarConfig = false;
    };

    catppuccin = {
      name = "catppuccin";
      src = "${sources.catppuccinSrc}/catppuccin";

      overwriteAssets = true;
      sidebarConfig = false;
    };
    dribbblish = {
      name = "Dribbblish";
      src = "${sources.officialThemes}/Dribbblish";
      requiredExtensions = [
        {
          src = "${sources.officialThemes}/Dribbblish";
          name = "theme.js";
        }
      ];
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32";
        "xpui.js_repl_8008" = ",\${1}56";
      };

      overwriteAssets = true;

      additionalCss = ''
        .Root {
          padding-top: 0px;
        }
      '';
    };

    text = {
      name = "text";
      src = "${sources.officialThemes}/text";
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)56";
        "xpui.js_repl_8008" = ",\${1}32";
      };

      sidebarConfig = false;
    };

    dreary = {
      name = "Dreary";
      src = "${sources.officialThemes}/Dreary";
    };
    turntable = {
      name = "Turntable";
      src = sources.officialThemes;
      requiredExtensions = [
        #"fullAppDisplay.js"
        {
          name = "turntable.js";
          src = "${sources.officialThemes}/Turntable";
        }
      ];
    };

    spotifyNoPremium = {
      name = "SpotifyNoPremium";
      src = sources.spotifyNoPremiumSrc;

      requiredExtensions = [ extensions.adblock ];
      injectCss = false;
      replaceColors = false;

      sidebarConfig = false;
    };

    fluent = {
      name = "Fluent";
      src = sources.fluentSrc;

      overwriteAssets = true;

      sidebarConfig = false;
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32";
        "xpui.js_repl_8008" = ",\${1}56";
      };
      requiredExtensions = [
        {
          src = sources.fluentSrc;
          name = "fluent.js";
        }
      ];
    };

    defaultDynamic = {
      name = "DefaultDynamic";
      src = sources.defaultDynamicSrc;

      sidebarConfig = false;
      requiredExtensions = [
        {
          src = sources.defaultDynamicSrc;
          name = "default-dynamic.js";
        }
        {
          src = sources.defaultDynamicSrc;
          name = "Vibrant.min.js";
        }
      ];
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32,";
        "xpui.js_repl_8008" = ",\${1}28,";
      };
    };

    retroBlur = {
      name = "RetroBlur";
      src = sources.retroBlurSrc;

      sidebarConfig = false;
    };

    # BROKEN. no clue why
    omni = {
      name = "Omni";
      src = sources.omniSrc;

      overwriteAssets = true;

      sidebarConfig = false;
      requiredExtensions = [
        {
          src = sources.omniSrc;
          name = "omni.js";
        }
      ];
    };

    # light colorscheme is broken, think that's the theme's fault
    bloom = {
      name = "Bloom";
      src = sources.bloomSrc;

      overwriteAssets = true;
      sidebarConfig = false;
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32,";
        "xpui.js_repl_8008" = ",\${1}56,";
      };
      requiredExtensions = [
        {
          src = sources.bloomSrc;
          name = "bloom.js";
        }
      ];
    };

    orchis = {
      name = "DarkGreen";
      src = "${sources.orchisSrc}/DarkGreen";
      extraPkgs = [ pkgs.fira ];

      sidebarConfig = false;
    };

    dracula = {
      name = "Dracula";
      src = "${sources.draculaSrc}/Dracula";

      injectCss = false;
      sidebarConfig = false;
    };

    nord = {
      name = "Nord";
      src = "${sources.nordSrc}/Nord";

      sidebarConfig = false;
    };

    comfy = {
      name = "Comfy";
      src = "${sources.comfySrc}/Comfy";

      overwriteAssets = true;
      sidebarConfig = false;
      requiredExtensions = [
        {
          src = "${sources.comfySrc}/Comfy";
          name = "theme.js";
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
      src = "${sources.spotifyCanvasSrc}/Themes/canvas";

      replaceColors = false;
      sidebarConfig = false;

      requiredExtensions = [
        {
          src = "${sources.spotifyCanvasSrc}/Extensions";
          name = "getCanvas.js";
        }
      ];
    };
  }
