{ 
  pkgs ? import <nixpkgs> {},
  theme ? "SpicetifyDefault",
  colorScheme ? "",
}:

let
  spicetifyPkg = pkgs.callPackage ./spicetify.nix {};
  spicetify = "SPICETIFY_CONFIG=. ${spicetifyPkg}/spicetify";

  themes = pkgs.callPackage ./themes.nix {};
in
pkgs.spotify.overrideAttrs (oldAttrs: rec {
  postInstall=''
    touch $out/prefs
    ln -s ${themes} Themes

    ${spicetify} config \
      spotify_path "$out/share/spotify" \
      prefs_path "$out/prefs" \
      current_theme ${theme} \
      color_scheme ${colorScheme}

  '' + (if theme == "Dribbblish" then ''
    ${spicetify} config \
      extensions dribbblish.js \
      inject_css 1 replace_colors 1 overwrite_assets 1

    cp ./Themes/Dribbblish/dribbblish.js ./Extensions
  '' else "") + ''

    ${spicetify} backup apply
  '';
})
