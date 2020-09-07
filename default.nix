{ 
  pkgs ? import <nixpkgs> {},
  theme ? "SpicetifyDefault",
  colorScheme ? "",
  enabledExtensions ? [],
  enabledCustomApps ? [],
  injectCss ? false,
  replaceColors ? false,
  overwriteAssets ? false,
}:

let
  inherit (pkgs.lib.lists) foldr;
  pipeConcat = foldr (a: b: a + "|" + b) "";
  boolToString = x: if x then "1" else "0";

  spicetifyPkg = pkgs.callPackage ./spicetify.nix {};
  spicetify = "SPICETIFY_CONFIG=. ${spicetifyPkg}/spicetify";

  themes = pkgs.callPackage ./themes.nix {};

  # Dribblish is a theme which needs a couple extra settings
  isDribblish = theme == "Dribbblish";
  extraCommands = if isDribblish then "cp ./Themes/Dribbblish/dribbblish.js ./Extensions" else "";
  
  injectCss = boolToString (isDribblish || injectCss);
  replaceColors = boolToString (isDribblish || replaceColors);
  overwriteAssets = boolToString (isDribblish || overwriteAssets);

  extensionString = pipeConcat ((if isDribblish then [ "dribbblish.js" ] else []) ++ enabledExtensions);
  customAppsString = pipeConcat enabledCustomApps;
in
pkgs.spotify.overrideAttrs (oldAttrs: rec {
  postInstall=''
    touch $out/prefs
    ln -s ${themes} Themes
    
    ${spicetify} config \
      spotify_path "$out/share/spotify" \
      prefs_path "$out/prefs" \
      current_theme ${theme} \
      color_scheme ${colorScheme} \
      ${if 
          extensionString != ""
        then 
          ''extensions "${extensionString}" \'' 
        else 
          ''\'' }
      ${if
          customAppsString != ""
        then 
          ''custom_apps "${customAppsString}" \'' 
        else 
          ''\'' }
      inject_css ${injectCss} \
      replace_colors ${replaceColors} \
      overwrite_assets ${overwriteAssets}

    ${extraCommands}

    ${spicetify} backup apply
  '';
})
