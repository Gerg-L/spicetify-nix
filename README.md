# Spicetify-Nix

Modifies Spotify using [spicetify-cli](https://github.com/khanhas/spicetify-cli).

Currently only supports changing the theme to a theme from [spicetify-themes](https://github.com/morpheusthewhite/spicetify-themes).

Usage:
```
pkgs.callPackage (import (fetchTarball https://github.com/pietdevries94/spicetify-nix/archive/master.tar.gz)) {
  inherit pkgs;
  theme = "Dribbblish";
  colorScheme = "horizon";
  enabledCustomApps = ["reddit"];
  enabledExtensions = ["newRelease.js"];
}
```

For all available options, check default.nix

Both theme and colorScheme are optional.