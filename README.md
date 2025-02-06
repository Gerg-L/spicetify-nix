# Spicetify-Nix

Originally forked from [the-argus](https://github.com/the-argus/spicetify-nix)
which forked from [pietdevries94](https://github.com/pietdevries94/spicetify-nix)
deleted and re-made repo for discoverability as github does not like to show forks in the search


Modifies Spotify using [spicetify-cli](https://github.com/spicetify/cli).

### Try it out

`nix run github:Gerg-L/spicetify-nix#test`

## Usage

Add this flake as an input
```nix
spicetify-nix.url = "github:Gerg-L/spicetify-nix";
```

or `import` the base of this repo with a `fetchTarball` passing `pkgs`

like `import (builtins.fetchTarball { ... } ) {inherit pkgs;}`

Then use one of the modules or `spicetify-nix.lib.mkSpicetify`


### Wrapper function
The wrapper takes two arguments `pkgs` and then an attribute set of config options

```nix
let
  spicetify = spicetify-nix.lib.mkSpicetify pkgs {
    #config options
  };
in {
...
```
then add it to `environment.systemPackages` or `users.users.<name>.packages` or anywhere you can add a package

### Modules
Import `{nixosModules,darwinModules,homeManagerModules}.spicetify` into your respective config

and use the `programs.spicetify` options

```nix
programs.spicetify = {
  enable = true;
  #config options
```

and it'll install the wrapped spotify to `environment.systemPackages` or `home.packages`

To not install by default use `programs.spicetify.dontInstall = true;`
 
Use: `config.programs.spicetify.spicedSpotify`
instead of `pkgs.spotify` to reference the spiced Spotify package

### Example Configuration

```nix
   let
     # For Flakeless:
     # spicePkgs = spicetify-nix.packages;

     # With flakes:
     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
   in
   programs.spicetify = {
     enable = true;
     enabledExtensions = with spicePkgs.extensions; [
       adblockify
       hidePodcasts
       shuffle # shuffle+ (special characters are sanitized out of extension names)
     ];
     theme = spicePkgs.themes.catppuccin;
     colorScheme = "mocha";
   }
```

## Config Options

See the generated docs:
<https://gerg-l.github.io/spicetify-nix/options.html>

## Themes, Extensions, and CustomApps

Are found in [THEMES.md](./docs/THEMES.md), [EXTENSIONS.md](./docs/EXTENSIONS.md), and
[CUSTOMAPPS.md](./docs/CUSTOMAPPS.md), respectively.
