# ~~Warning: Spotify Sucks~~
~~Linux is a second class citizen on Spotify's release plan, but because it isn't FOSS, there's nothing we can do. Right now a lot of themes and extensions don't work because spotify isn't up to date on Linux. This includes Dribbblish :(~~

# EDIT: nevermind
Turns out using spicetify 2.9.9 and the most recent CSS map fixes most (or all) of the issues. Use the following configuration option to get spicetify 2.9.9:
```nix
{
  programs.spicetify.spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (oa: rec {
    pname = "spicetify-cli";
    version = "2.9.9";
    src = pkgs.fetchgit {
      url = "https://github.com/spicetify/${pname}";
      rev = "v${version}";
      sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
    };
  });
}
```
# Spicetify-Nix

Modifies Spotify using [spicetify-cli](https://github.com/khanhas/spicetify-cli).

[spicetify-themes](https://github.com/morpheusthewhite/spicetify-themes) are included and available.

# Usage

To use, add this flake to your home-manager configuration flake inputs, like so:
```nix
{
  inputs.spicetify-nix.url = "github:the-argus/spicetify-nix";
}
```
## Configuration examples

Here are two examples of files which configures spicetify when imported into a users home-manager configuration.

### Minimal Configuration
```nix
{ pkgs, unstable, lib, spicetify-nix, ... }:
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify-unwrapped"
  ];

  # import the flake's module
  imports = [ spicetify-nix.homeManagerModule ];

  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;
      theme = "catppuccin-mocha";
      # OR 
      # theme = spicetify-nix.pkgs.themes.catppuccin-mocha;
      colorScheme = "flamingo";

      enabledExtensions = [
        "fullAppDisplay.js"
        "shuffle+.js"
        "hidePodcasts.js"
      ];
    };
}
```

### MAXIMUM CONFIGURATION
```nix
{ pkgs, unstable, lib, spicetify-nix, ... }:
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify-unwrapped"
  ];

  # import the flake's module
  imports = [ spicetify-nix.homeManagerModule ];

  # configure spicetify :)
  programs.spicetify =
    let
      # use a different version of spicetify-themes than the one provided by
      # spicetify-nix
      officialThemesOLD = pkgs.fetchgit {
        url = "https://github.com/spicetify/spicetify-themes";
        rev = "c2751b48ff9693867193fe65695a585e3c2e2133";
        sha256 = "0rbqaxvyfz2vvv3iqik5rpsa3aics5a7232167rmyvv54m475agk";
      };
      # pin a certain version of the localFiles custom app
      localFilesSrc = pkgs.fetchgit {
        url = "https://github.com/hroland/spicetify-show-local-files/";
        rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
        sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
      };
    in
    {
      # use spotify from the nixpkgs master branch
      spotifyPackage = unstable.spotify-unwrapped;
      # use a custom build of spicetify, also an old version.
      spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (oa: rec {
        pname = "spicetify-cli";
        version = "2.9.9";
        src = pkgs.fetchgit {
          url = "https://github.com/spicetify/${pname}";
          rev = "v${version}";
          sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
        };
      });

      # actually enable the installation of spotify and spicetify
      enable = true;

      # custom Dribbblish theme
      theme = {
        name = "Dribbblish";
        src = officialThemesOLD;
        requiredExtensions = [
          # define extensions that will be installed with this theme
          {
            # extension is "${src}/Dribbblish/dribbblish.js"
            filename = "dribbblish.js";
            src = "${officialThemesOLD}/Dribbblish";
          }
        ];
        appendName = true; # theme is located at "${src}/Dribbblish" not just "${src}"

        # changes to make to config-xpui.ini for this theme:
        patches = {
          "xpui.js_find_8008" = ",(\\w+=)32,";
          "xpui.js_repl_8008" = ",$\{1}56,";
        };
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
      };

      # specify that we want to use our custom colorscheme
      colorScheme = "custom";
      
      # color definition for custom color scheme. (rosepine)
      customColorScheme = {
        text = "ebbcba";
        subtext = "F0F0F0";
        sidebar-text = "e0def4";
        main = "191724";
        sidebar = "2a2837";
        player = "191724";
        card = "191724";
        shadow = "1f1d2e";
        selected-row = "797979";
        button = "31748f";
        button-active = "31748f";
        button-disabled = "555169";
        tab-active = "ebbcba";
        notification = "1db954";
        notification-error = "eb6f92";
        misc = "6e6a86";
      };
      
      enabledCustomApps = with spicetify-nix.pkgs.apps; [
        new-releases
        {
            name = "localFiles";
            src = localFilesSrc;
            appendName = false;
        }
      ];
      enabledExtensions = with spicetify-nix.pkgs.extensions; [
        "playlistIcons.js"
        "lastfm.js"
        "genre.js"
        "historyShortcut.js"
        "hidePodcasts.js"
        "fullAppDisplay.js"
        "shuffle+.js"
      ];
    };
}
```

## Themes, Extensions, and CustomApps

Are found in [THEMES.md](./THEMES.md), [EXTENSIONS.md](./EXTENSIONS.md), and [CUSTOMAPPS.md](./CUSTOMAPPS.md), respectively.

## macOS
This package has no macOS support, because Spotify in nixpkgs has no macOS support.
