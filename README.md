# Spicetify-Nix

Originally forked from [the-argus](https://github.com/the-argus/spicetify-nix)
which forked from [the-argus](https://github.com/pietdevries94/spicetify-nix)
deleted and re-made repo for discoverability as github does not like to show forks in the search


Modifies Spotify using [spicetify-cli](https://github.com/spicetify/spicetify-cli).

[spicetify-themes](https://github.com/spicetify/spicetify-themes) are
included and available.

## Usage

Add this flake as an input
```nix
#flake.nix
{
  inputs = {
    nvim-flake = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
...
```
(Make sure you're passing inputs to your [modules](https://blog.nobbz.dev/posts/2022-12-12-getting-inputs-to-modules-in-a-flake))

## Import the module
```nix
  imports = [
    # For NixOS
    inputs.spicetify-nix.nixosModules.default
    # For home-manager
    inputs.spicetify-nix.homeManagerModules.default
  ];
```
(Ensure you have spotify allowed as [unfree](https://wiki.nixos.org/wiki/Unfree_Software))

### Minimal Configuration

```nix
programs.spicetify =
   let
     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
   in
   {
     enable = true;
     enabledExtensions = with spicePkgs.extensions; [
       adblock
       hidePodcasts
       shuffle # shuffle+ (special characters are sanitized out of extension names)
     ];
     theme = spicePkgs.themes.catppuccin;
     colorScheme = "mocha";
   }
```

## Themes, Extensions, and CustomApps

Are found in [THEMES.md](./docs/THEMES.md), [EXTENSIONS.md](./docs/EXTENSIONS.md), and
[CUSTOMAPPS.md](./docs/CUSTOMAPPS.md), respectively.
