{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.spicetify;
in
{
  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      spicedSpotify = cfg.__internal_spotify;
    };

    environment.systemPackages = lib.mkIf (!cfg.dontInstall) cfg.createdPackages;
  };
}
