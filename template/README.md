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
Additionally, change ``homeConfigUserString`` in ``flake.nix`` to be equal to
``username``.

If you want to add this configuration to a git repository, create one
(for example, on github) and then link it up to this folder by running:

```bash
git remote add origin https://github.com/your-username/repo-name
git push -u origin main
```

(``git remote rm origin`` is also useful if you accidentally add the wrong url)

## Known issues

If you're on Fedora linux, SELinux is enabled by default, and it breaks nix.
Edit ``/etc/selinux/config`` and change ``SELINUX=enforcing`` to
``SELINUX=disabled`` and then restart your machine to disable it.
