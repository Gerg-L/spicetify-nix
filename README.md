# Spicetify-Nix

# Warning: currently nonfunctional, WIP
The project I forked this from invoked spicetify-cli in order to change
configuration values. I'm going to have to switch to an ini generator
instead, because spicetify auto-generates the config ini if it's not there
(and seems to always use the default configuration values).

Modifies Spotify using [spicetify-cli](https://github.com/khanhas/spicetify-cli).

[spicetify-themes](https://github.com/morpheusthewhite/spicetify-themes) are included and available, including Dribblish.

To use, add this flake to your home-manager configuration flake inputs, like so:
```nix
spicetify-nix = {
  url = "github:the-argus/spicetify-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

An example of a file which configures spicetify when imported into
a users home-manager configuration:
```nix
{ pkgs, spicetify-nix, ... }:
{
  imports = [ (import "${spicetify-nix}/module.nix") ];

  programs.spicetify =
    let
      av = pkgs.fetchFromGitHub {
        owner = "amanharwara";
        repo = "spicetify-autoVolume";
        rev = "d7f7962724b567a8409ef2898602f2c57abddf5a";
        sha256 = "1pnya2j336f847h3vgiprdys4pl0i61ivbii1wyb7yx3wscq7ass";
      };
    in
    {
      enable = true;
      theme = "Dribbblish";
      colorScheme = "horizon";
      enabledCustomApps = [ "reddit" ];
      enabledExtensions = [ "newRelease.js" "autoVolume.js" ];
      thirdParyExtensions = {
        "autoVolume.js" = "${av}/autoVolume.js";
      };
    };
}
```

To add third-party themes, extensions or custom apps use `thirdParyThemes`, `thirdParyExtensions` or `thirdParyCustomApps`. These expect a set, where the key is the name of the new theme/extension and the value the path. Don't forget to enable it seperatly.

For all available options, check module.nix or package.nix and the spicetify repo. Everything is optional and will revert to the defaults from spicetify.

## macOS
This package has no macOS support, because Spotify in nixpkgs has no macOS support.
