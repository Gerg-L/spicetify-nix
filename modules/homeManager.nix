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

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.spicetify = {
        spicedSpotify =
          assert lib.assertMsg (!(pkgs.stdenv.isDarwin && cfg.windowManagerPatch)) ''
            Spotifywm does not support darwin
          '';
          assert lib.assertMsg (cfg.spotifyPackage.pname != "spotifywm") ''
            Do not set spotifyPackage to pkgs.spotifywm
            instead enable windowManagerPatch and set spotifywmPackage
          '';
          if cfg.windowManagerPatch then
            (cfg.spotifywmPackage.override { spotify = cfg.__interal_spotify; }).overrideAttrs (old: {
              passthru = (old.passthru or { }) // cfg.__interal_spotify.passthru;
            })
          else
            cfg.__interal_spotify;
        createdPackages = [ cfg.spicedSpotify ] ++ cfg.theme.extraPkgs;
      };
    })

    (lib.mkIf (!cfg.dontInstall) {
      environment.systemPackages = cfg.createdPackages;
    })
  ];
}
