{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.spicetify =
    { config, ... }:
    {
      imports = [ ./wmOpts.nix ];
      spicedSpotify =
        assert lib.assertMsg (!(pkgs.stdenv.isDarwin && config.windowManagerPatch)) ''
          Spotifywm does not support darwin
        '';
        assert lib.assertMsg (config.spotifyPackage.pname != "spotifywm") ''
          Do not set spotifyPackage to pkgs.spotifywm
          instead enable windowManagerPatch and set spotifywmPackage
        '';
        if config.windowManagerPatch then
          (config.spotifywmPackage.override { spotify = config.__internal_spotify; }).overrideAttrs (old: {
            passthru = (old.passthru or { }) // config.__internal_spotify.passthru;
          })
        else
          config.__internal_spotify;
    };
  home.packages = lib.mkIf config.programs.spicetify.enable config.programs.spicetify.createdPackages;
}
