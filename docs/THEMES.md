# Themes
## Using unpackaged themes
```nix
programs.spicetify.theme = {
  # Name of the theme (duh)
  name = "";
  # The source of the theme
  # make sure you're using the correct branch
  # It could also be a sub-directory of the repo
  src = pkgs.fetchFromGitHub {
    owner = "";
    repo = "";
    rev = "";
    hash = "";
  };
  
  # Additional theme options all set to defaults
  # the docs of the theme should say which of these 
  # if any you have to change
  injectCss = true;
  injectThemeJs = true;
  replaceColors = true;
  homeConfig = true;
  overwriteAssets = false;
  additonalCss = "";
}
```

Almost all theme PR's will be merged quickly
view the git history of /pkgs/themes.nix for PR examples



## Official Themes
All of these themes can be found [here.](https://github.com/spicetify/spicetify-themes)
### default
Identical to the default look of spotify, but with other colorschemes available.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Default/ocean.png)
### blossom
A little theme for your Spotify client
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Blossom/images/home.png)]
### burntSienna
Grey and orange theme using the montserrat typeface.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/BurntSienna/screenshot.png)
### dreary
Flat design, with lots of thick line borders.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Dreary/bib.png)
### dribbblish
Modern, rounded, and minimal design, with fading effects and gradients.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Dribbblish/base.png)
### flow
Monochromatic colorschemes with subtle differences between colors, and soft vertical gradients.
![preview](https://raw.githubusercontent.com/spicetify/spicetify-themes/master/Flow/screenshots/ocean.png)
### matte 
A distinct top bar, quick-to-edit CSS variables, and color schemes from Windows visual styles by KDr3w
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Matte/screenshots/queue.png)
### nightlight
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Nightlight/screenshots/nightlight.png)
### onepunch
Gruvbox.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Onepunch/screenshots/dark_home.png)
### sleek
Flat design, with dark blues for the background and single highlight colors in each scheme.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Sleek/bladerunner.png)
### staryNight
![preview](https://github.com/spicetify/spicetify-themes/blob/master/StarryNight/images/base.png)
Simple theme with a pure CSS Shooting Star Animation Effect
### turntable
Default spotify, but provides a spinning image of a record when used with fullAppDisplay.js
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Turntable/screenshots/fad.png)
### ziro
Inspired by the Zorin GTK theme.
![preview](https://raw.githubusercontent.com/schnensch0/ziro/main/preview/album-blue-dark.png)
### text
A TUI-like theme.
![preview](https://raw.githubusercontent.com/spicetify/spicetify-themes/master/text/screenshots/Spotify.png)

## Community Themes
### catppuccin
A soothing pastel theme for spotify. Comes in four color schemes: mocha, frappe, latte, and macchiato. [Source](https://github.com/catppuccin/spicetify)
![preview](https://github.com/catppuccin/spicetify/blob/main/assets/preview.webp)
### comfy
Stay comfy while listening to music. Rounded corners and dark blues. Comes in many variations. [Source](https://github.com/Comfy-Themes/Spicetify)
![preview](https://github.com/Comfy-Themes/Spicetify/blob/main/images/color-schemes/comfy.png)
### dracula
Default spotify with the colors of the popular scheme. [Source](https://github.com/Darkempire78/Dracula-Spicetify)
![preview](https://github.com/Darkempire78/Dracula-Spicetify/blob/master/screenshot.png)
### nord
Default spotify with the colors of the popular scheme. [Source](https://github.com/Tetrax-10/Nord-Spotify)
![preview](https://raw.githubusercontent.com/Tetrax-10/Nord-Spotify/master/assets/nord/libx/libx-home-page.png)
### spotifyCanvas
A theme attempting to bring canvas, the video/clip player, to spotify desktop. It normally is only available on mobile. [Source](https://github.com/itsmeow/Spicetify-Canvas)
![preview](https://camo.githubusercontent.com/c1c042a751f8277cd31f0091fac874f5841d31e969483af1134e964a44ec0cb5/68747470733a2f2f692e696d6775722e636f6d2f6275647263454e2e676966)
### spotifyNoPremium
Same as default spotify but without ads and anything related to getting premium. [Source](https://github.com/Daksh777/SpotifyNoPremium)
![preview](https://camo.githubusercontent.com/7d8bea70db4173dd0bebffbf777695da77547c24173a48b898b2d1167c1114bf/68747470733a2f2f692e696d6775722e636f6d2f6b4566664479382e706e67)
### fluent
Inspired by the design of Windows 11. [Source](https://github.com/williamckha/spicetify-fluent)
![preview](https://github.com/williamckha/spicetify-fluent/blob/master/screenshots/dark-1.png)
### defaultDynamic
Same as default spotify, but colors change dynamically with album art. [Source](https://github.com/JulienMaille/spicetify-dynamic-theme)
![preview](https://github.com/JulienMaille/spicetify-dynamic-theme/blob/main/preview.gif)
### retroBlur
Synthwave theme with a lot of blur and effects. [Source](https://github.com/Motschen/Retroblur)
![preview](https://github.com/Motschen/Retroblur/blob/main/preview/playlist.png)
### omni
Dark theme created by Rocketseat. [Source](https://github.com/getomni/spicetify)
![preview](https://github.com/getomni/spicetify/blob/main/screenshot.png)
### bloom
Another Spicetify theme inspired by Microsoft's Fluent Design System. [Source](https://github.com/nimsandu/spicetify-bloom)
![preview](https://github.com/sanoojes/Spicetify-Lucid/blob/main/assets/images/lucid-control-nav.png)
### lucid
A minimal and dynamic Bloom-inspired theme for Spicetify. [Source](https://github.com/sanoojes/Spicetify-Lucid)
![preview](https://github.com/nimsandu/spicetify-bloom/blob/main/images/dark.png)
### orchis
Simple dark green/grey theme. [Source](https://github.com/canbeardig/Spicetify-Orchis-Colours-v2)
![preview](https://github.com/canbeardig/Spicetify-Orchis-Colours-v2/blob/main/screenshot.png)

