{ sources, pkgs, }:

{
  pocket = {
    src = "${sources.AroLucy_1}/Pocket";
    name = "Pocket";
   # should be in .spicetify/extensions
    requiredExtensions = [
      {
        src = "${sources.AroLucy_1}";
        name = "Pocket.js";
      }
      {
        src = "${sources.AroLucy_1}";
        name = "VolumeBeforeHover.js";
      }
    ];
  };
  sidebarControls = {
    src = "${sources.AroLucy_2}";
    name = "SidebarControls";
   # should be in .spicetify/extensions
    requiredExtensions = [
      {
        src = "${sources.AroLucy_2}";
        name = "VolumeBeforeHover.js";
      }
    ];
  };

  hazy = {
    src = "${sources.Astromations}";
    name = "Hazy";
    overwriteAssets = true;
  };

  throwback = {
    src = "${sources.bluedrift}/Throwback";
    name = "Throwback";
  };

  orchis = {
    src = "${sources.canbeardig}/DarkGreen";
    name = "DarkGreen";
    extraPkgs = [ pkgs.fira ];
  };


  catppuccin = {
    src = "${sources.catppuccin}/catppuccin";
    name = "Catppuccin";
    overwriteAssets = true;
    requiredExtensions = [
      {
        src = "${sources.catppuccin}/catppuccin";
        name = "theme.js";
      }
    ];
  };

  comfy = {
    src = "${sources.Comfy-Themes}/Comfy";
    name = "Comfy";
    # below copied, don't know how/if it works
    overwriteAssets = true;
    requiredExtensions = [
      {
        src = "${sources.Comfy-Themes}/Comfy";
        name = "theme.js";
      }
    ];
    extraCommands = ''
      # remove the auto-update functionality
      echo "\n" >> ./Extensions/theme.js
      cat ./Themes/Comfy/theme.script.js >> ./Extensions/theme.js
    '';
  };

  dracula = {
    src = "${sources.dracula}/Dracula";
    name = "Dracula";
  };

  simpleOutline = {
    src = "${sources.Droidiar}";
    name = "SimpleOutline";
  };

  omni = {
    src = "${sources.getomni}";
    name = "Omni";

    overwriteAssets = true;

    requiredExtensions = [
      {
        src = sources.omniSrc;
        name = "omni.js";
      }
    ];
  };

  galaxy = {
    src = "${sources.harbassan-themes}";
    name = "Galaxy";
    overwriteAssets = true;
    requiredExtensions = [
      {
        src = "${sources.harbassan-themes}";
        name = "theme.js";
      }
    ];
  };

  revertX2 = {
    src = "${sources.JayTheXXVII}/src";
    name = "RevertX2";
    requiredExtensions = [
      {
        src = "${sources.JayTheXXVII}/src";
        name = "theme.js";
      }
    ];
  };

  defaultDynamic = {
    src = "${sources.JulienMaille_1}";
    name = "DefaultDynamic";
    requiredExtensions = [
      {
        src = "${sources.JulienMaille_1}";
        name = "default-dynamic.js";
      }
      {
        src = "${sources.JulienMaille_1}";
        name = "Vibrant.min.js";
      }
    ];
  };
  dribbblishDynamic = {
    src = "${sources.JulienMaille_2}";
    name = "DribbblishDynamic";
    requiredExtensions = [
      {
        src = "${sources.JulienMaille_2}";
        name = "dribbblish-dynamic.js";
      }
      {
        src = "${sources.JulienMaille_2}";
        name = "Vibrant.min.js";
      }
    ];
  };

  pinkers = {
    src = "${sources.Kennubyte}";
    name = "Pinkers";
  };

  grayscale = {
    src = "${sources.LimeAndPyro}";
    name = "Grayscale";
  };

  accented = {
    src = "${sources.luximus-hunter}";
    name = "Accented";
  };

  retroblur = {
    src = "${sources.Motschen}";
    name = "Retroblur";
    requiredExtensions = [
      {
        src = "${sources.Motschen}";
        name = "theme.js";
      }
    ];
  };

  sharkBlue = {
    src = "${sources.MrBiscuit921}/SharkBlue";
    name = "SharkBlue";
  };

  bloom = {
    src = "${sources.nimsandu}/src";
    name = "Bloom";
    overwriteAssets = true;
    requiredExtensions = [
      {
        src = "${sources.nimsandu}/src";
        name = "theme.js";
      }
    ];
  };

  burntSienna = {
    src = "${sources.pjaspinksi}/BurntSienna";
    name = "BurntSienna";
    extraPkgs = [ pkgs.montserrat ];
  };

  notRetroblur = {
    src = "${sources.Rubutter}";
    name = "notRetroblur";
  };

  colorful = {
    src = "${sources.sanoojes-themes_1}/src";
    name = "Colorful";
    overwriteAssets = true;
  };
  lucid = {
    name = "Lucid";
    src = "${sources.sanoojes-themes_2}/src";
    overwriteAssets = true;
    requiredExtensions = [
      {
        src = "${sources.sanoojes-themes_2}/src";
        name = "theme.js";
      }
    ];
  };
  shadeX = {
    src = "${sources.sanoojes-themes_3}/src";
    name = "ShadeX";
    overwriteAssets = true;
    requiredExtensions = [
      {
        src = "${sources.sanoojes-themes_3}/src";
        name = "theme.js";
      }
    ];
  };

  blossom = {
    src = "${sources.Spicetify-themes}/Blossom";
    name = "Blossom";
  };
  default = {
    src = "${sources.Spicetify-themes}/Default";
    name = "Default";
  };
  dreary = {
    src = "${sources.Spicetify-themes}/Dreary";
    name = "Dreary";
  };
  dribbblish = {
    src = "${sources.Spicetify-themes}/Dribbblish";
    name = "Dribbblish";
    requiredExtensions = [
      {
        src = "${sources.Spicetify-themes}/Dribbblish";
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
  flow = {
    src = "${sources.Spicetify-themes}/Flow";
    name = "Flow";
  };
  matte = {
    src = "${sources.Spicetify-themes}/Matte";
    name = "Matte";
  };
  onepunch = {
    src = "${sources.Spicetify-themes}/Onepunch";
    name = "Onepunch";
  };
  sleek = {
    src = "${sources.Spicetify-themes}/Sleek";
    name = "Sleek";
  };
  starryNight = {
    src = "${sources.Spicetify-themes}/StarryNight";
    name = "StarryNight";
    requiredExtensions = [
      {
        src = "${sources.Spicetify-themes}/StarryNight";
        name = "theme.js";
      }
    ];
  };
  text = {
    src = "${sources.Spicetify-themes}/text";
    name = "text";
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)56";
      "xpui.js_repl_8008" = ",\${1}32";
    };
  };
  turntable = {
    src = "${sources.Spicetify-themes}/Turntable";
    name = "Turntable";
    requiredExtensions = [
      #"fullAppDisplay.js"
      {
        name = "theme.js";
        src = "${sources.Spicetify-themes}/Turntable";
      }
    ];
  };
  ziro = {
    src = "${sources.Spicetify-themes}/Ziro";
    name = "Ziro";
  };

  spotifyDark = {
    src = "${sources.SyndiShanX-themes}";
    name = "SpotifyDark";
    requiredExtensions = [
      {
        src = "${sources.SyndiShanX-themes}";
        name = "rainbow.js";
      }
      {
        src = "${sources.SyndiShanX-themes}";
        name = "zoomTheme.js";
      }
    ];
  };

  blackout = {
    src = "${sources.thefoodiee}";
    name = "Blackout";
  };

  fluent = {
    src = "${sources.williamckha}";
    name = "Fluent";
    overwriteAssets = true;
    requiredExtensions = [
      {
        src = "${sources.williamckha}";
        name = "fluent.js";
      }
    ];
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)32";
      "xpui.js_repl_8008" = ",\${1}56";
    };
  };
}
