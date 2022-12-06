# Home Manager Configuration

This home-manager configuration was generated from the spicetify-nix template.
You will find settings for the system (for if youre not running x86_64
architecture) and username inside of `flake.nix`. Edit `spicetify.nix` in
order to customize what theme, extensions, custom apps, and color scheme you
are using.

Check the [spicetify-nix README](https://github.com/the-argus/spicetify-nix/blob/master/README.md)
for documentation on ways you can configure spicetify.

## Further configuration

If you are on NixOS linux, you can remove the line
``targets.genericLinux.enable = true;`` from ``home.nix``.
