{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.spicetify;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.spicetify = {
        spicedSpotify = cfg.__internal_spotify;
        createdPackages = [ cfg.spicedSpotify ] ++ cfg.theme.extraPkgs;
      };
    })

    (lib.mkIf (!cfg.dontInstall) {
      environment.systemPackages = cfg.createdPackages;
    })
  ];
}
