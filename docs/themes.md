---
title: Themes
---
# {{ $frontmatter.title }}

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

Almost all theme PR's will be merged quickly view the git history of
/pkgs/themes.nix for PR examples

## Official Themes

All of these themes can be found
[here.](https://github.com/spicetify/spicetify-themes)

### default

Identical to the default look of spotify, but with other colorschemes available.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Default/ocean.png?raw=true)

### blossom

A little theme for your Spotify client
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Blossom/images/home.png?raw=true)

### burntSienna

Grey and orange theme using the montserrat typeface.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/BurntSienna/screenshot.png?raw=true)

### dreary

Flat design, with lots of thick line borders.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Dreary/bib.png?raw=true)

### dribbblish

Modern, rounded, and minimal design, with fading effects and gradients.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Dribbblish/base.png?raw=true)

### flow

Monochromatic colorschemes with subtle differences between colors, and soft
vertical gradients.
![preview](https://raw.githubusercontent.com/spicetify/spicetify-themes/master/Flow/screenshots/ocean.png?raw=true)

### matte

A distinct top bar, quick-to-edit CSS variables, and color schemes from Windows
visual styles by KDr3w
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Matte/screenshots/ylx-matte.png?raw=true)

### nightlight

![preview](https://github.com/spicetify/spicetify-themes/blob/master/Nightlight/screenshots/nightlight.png?raw=true)

### onepunch

Gruvbox.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Onepunch/screenshots/dark_home.png?raw=true)

### sleek

Flat design, with dark blues for the background and single highlight colors in
each scheme.
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Sleek/bladerunner.png?raw=true)

### starryNight

![preview](https://github.com/spicetify/spicetify-themes/blob/master/StarryNight/images/base.png?raw=true)
Simple theme with a pure CSS Shooting Star Animation Effect

### turntable

Default spotify, but provides a spinning image of a record when used with
fullAppDisplay.js
![preview](https://github.com/spicetify/spicetify-themes/blob/master/Turntable/screenshots/fad.png?raw=true)

### ziro

Inspired by the Zorin GTK theme.
![preview](https://raw.githubusercontent.com/schnensch0/ziro/main/preview/album-blue-dark.png?raw=true)

### text

A TUI-like theme.
![preview](https://raw.githubusercontent.com/spicetify/spicetify-themes/master/text/screenshots/Spotify.png?raw=true)

## Community Themes

### catppuccin

A soothing pastel theme for spotify. Comes in four color schemes: mocha, frappe,
latte, and macchiato. [Source](https://github.com/catppuccin/spicetify)
![preview](https://github.com/catppuccin/spicetify/blob/main/assets/preview.webp?raw=true)

### comfy

Stay comfy while listening to music. Rounded corners and dark blues. Comes in
many variations. [Source](https://github.com/Comfy-Themes/Spicetify)
![preview](https://github.com/Comfy-Themes/Spicetify/blob/main/images/color-schemes/comfy.png?raw=true)

### dracula

Default spotify with the colors of the popular scheme.
[Source](https://github.com/Darkempire78/Dracula-Spicetify)
![preview](https://github.com/Darkempire78/Dracula-Spicetify/blob/master/screenshot.png?raw=true)

### nord

Default spotify with the colors of the popular scheme.
[Source](https://github.com/Tetrax-10/Nord-Spotify)
![preview](https://raw.githubusercontent.com/Tetrax-10/Nord-Spotify/master/assets/nord/libx/libx-home-page.png?raw=true)

### fluent

Inspired by the design of Windows 11.
[Source](https://github.com/williamckha/spicetify-fluent)
![preview](https://github.com/williamckha/spicetify-fluent/blob/master/screenshots/dark-1.png?raw=true)

### defaultDynamic

Same as default spotify, but colors change dynamically with album art.
[Source](https://github.com/JulienMaille/spicetify-dynamic-theme)
![preview](https://github.com/JulienMaille/spicetify-dynamic-theme/blob/main/preview.gif?raw=true)

### dribbblishDynamic

Modern, rounded, and minimal design, with fading effects and gradients, and dynamic. [Source](https://github.com/JulienMaille/dribbblish-dynamic-theme)
![preview](https://github.com/JulienMaille/dribbblish-dynamic-theme/blob/main/preview.png?raw=true)

### retroBlur

Synthwave theme with a lot of blur and effects.
[Source](https://github.com/Motschen/Retroblur)
![preview](https://github.com/Motschen/Retroblur/blob/main/preview/playlist.png?raw=true)

### omni

Dark theme created by Rocketseat. [Source](https://github.com/getomni/spicetify)
![preview](https://github.com/getomni/spicetify/blob/main/screenshot.png?raw=true)

### bloom

Another Spicetify theme inspired by Microsoft's Fluent Design System.
[Source](https://github.com/nimsandu/spicetify-bloom)
![preview](https://github.com/nimsandu/spicetify-bloom/blob/main/images/dark.png?raw=true)

### lucid

A minimal and dynamic Bloom-inspired theme for Spicetify.
[Source](https://github.com/sanoojes/Spicetify-Lucid)
![preview](https://github.com/sanoojes/Spicetify-Lucid/blob/main/assets/images/base.png?raw=true)

### orchis

Simple dark green/grey theme.
[Source](https://github.com/canbeardig/Spicetify-Orchis-Colours-v2)
![preview](https://github.com/canbeardig/Spicetify-Orchis-Colours-v2/blob/main/screenshot.png?raw=true)

### hazy

A translucent spicetify theme. [Source](https://github.com/Astromations/Hazy)
![preview](https://github.com/Astromations/Hazy/blob/main/hazy_home.png?raw=true)
