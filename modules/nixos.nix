{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.spicetify;
in
{
  options.programs.spicetify = {
    windowManagerPatch = lib.mkEnableOption "preloading the spotifywm patch";
    spotifywmPackage = lib.mkPackageOption pkgs "spotifywm" { };
  };

  config = {
    programs.spicetify = {
      spicedSpotify =
        assert lib.assertMsg (cfg.spotifyPackage.pname != "spotifywm") ''
          Do not set spotifyPackage to pkgs.spotifywm
          instead enable windowManagerPatch and set spotifywmPackage
        '';
        if cfg.windowManagerPatch then
          (cfg.spotifywmPackage.override { spotify = cfg.__internal_spotify; }).overrideAttrs (old: {
            passthru = (old.passthru or { }) // cfg.__internal_spotify.passthru;
          })
        else
          cfg.__internal_spotify;
    };

    environment.systemPackages = lib.mkIf cfg.enable cfg.createdPackages;
  };
}
