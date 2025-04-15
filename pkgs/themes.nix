{
  sources,
  pkgs,
  lib,
}:
(lib.genAttrs
  [
    "blossom"
    "default"
    "flow"
    "matte"
    "nightlight"
    "onepunch"
    "sharkBlue"
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

    }
  )
)
//

  {
    spotifyNoPremium = throw  "spotifyNoPremium is no longer being maintained as of 11/2024"; # added 04/2025

    burntSienna = {
      name = "BurntSienna";
      src = "${sources.officialThemes}/BurntSienna";
      extraPkgs = [ pkgs.montserrat ];

    };

    catppuccin = {
      name = "catppuccin";
      src = "${sources.catppuccinSrc}/catppuccin";

      overwriteAssets = true;

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
          name = "theme.js";
          src = "${sources.officialThemes}/Turntable";
        }
      ];
    };

    fluent = {
      name = "Fluent";
      src = sources.fluentSrc;

      overwriteAssets = true;

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

    };

    # BROKEN. no clue why
    omni = {
      name = "Omni";
      src = sources.omniSrc;

      overwriteAssets = true;

      requiredExtensions = [
        {
          src = sources.omniSrc;
          name = "omni.js";
        }
      ];
    };

    bloom = {
      name = "Bloom";
      src = "${sources.bloomSrc}/src";
      overwriteAssets = true;

    };
    # originally based on bloom
    lucid = {
      name = "Lucid";
      src = "${sources.lucidSrc}/src";
      overwriteAssets = true;
      requiredExtensions = [
        {
          src = "${sources.lucidSrc}/src";
          name = "theme.js";
        }
      ];
    };

    orchis = {
      name = "DarkGreen";
      src = "${sources.orchisSrc}/DarkGreen";
      extraPkgs = [ pkgs.fira ];

    };

    dracula = {
      name = "Dracula";
      src = "${sources.draculaSrc}/Dracula";

      injectCss = false;

    };

    nord = {
      name = "Nord";
      src = "${sources.nordSrc}/Nord";

    };

    comfy = {
      name = "Comfy";
      src = "${sources.comfySrc}/Comfy";

      overwriteAssets = true;

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

    hazy = {
      name = "Hazy";
      src = sources.hazySrc;
      requiredExtensions = [
        {
          name = "hazy.js";
          src = "${sources.hazySrc}";
        }
      ];
    };
  }
