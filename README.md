# Spicetify-Nix

Originally forked from [the-argus](https://github.com/the-argus/spicetify-nix)
which forked from [the-argus](https://github.com/pietdevries94/spicetify-nix)
deleted and re-made repo for discoverability as github does not like to show forks in the search


Modifies Spotify using [spicetify-cli](https://github.com/spicetify/spicetify-cli).

[spicetify-themes](https://github.com/spicetify/spicetify-themes) are
included and available.

## Usage

To use, add this flake to your home-manager configuration flake inputs, like so:

```nix
{
  inputs.spicetify-nix = {
    url = "github:Gerg-L/spicetify-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}

```

## Configuration examples

Here are two examples of files which configure spicetify when imported into a
user's home-manager configuration.

### Minimal Configuration

```nix
{ pkgs, lib, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  # import the flake's module for your system
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
      ];
    };
}
```

### Maximal configuration

NOTE: the purpose of this configuration is to demonstrate all the possible
customization options. It's not sane at all, and I see no reason why you
should actually use this one.

```nix
{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system};
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  # import the flake's module
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

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
      # use spotify from the nixpkgs unstable branch
      spotifyPackage = inputs.nixpkgs-unstable.spotify;

      # use a custom build of spicetify
      spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (oa: rec {
        pname = "spicetify-cli";
        version = "2.14.1";
        src = pkgs.fetchgit {
          url = "https://github.com/spicetify/${pname}";
          rev = "v${version}";
          sha256 = "sha256-262tnSKX6M9ggm4JIs0pANeq2JSNYzKkTN8awpqLyMM=";
        };
        vendorSha256 = "sha256-E2Q+mXojMb8E0zSnaCOl9xp5QLeYcuTXjhcp3Hc8gH4=";
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
      
      enabledCustomApps = with spicePkgs.apps; [
        new-releases
        {
          name = "localFiles";
          src = localFilesSrc;
          appendName = false;
        }
      ];
      enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        lastfm
        historyShortcut
        hidePodcasts
        fullAppDisplay
        shuffle
      ];
    };
}
```

## Themes, Extensions, and CustomApps

Are found in [THEMES.md](./THEMES.md), [EXTENSIONS.md](./EXTENSIONS.md), and
[CUSTOMAPPS.md](./CUSTOMAPPS.md), respectively.

## macOS

This package has no macOS support, because I don't have access to a macOS system
