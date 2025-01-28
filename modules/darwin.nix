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
      createdPackages = [ cfg.spicedSpotify ] ++ cfg.theme.extraPkgs;
    };

    environment.systemPackages = lib.mkIf (!cfg.dontInstall) cfg.createdPackages;
  };
}
