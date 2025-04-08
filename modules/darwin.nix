{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.spicetify;
in
{
  config = {
    programs.spicetify = {
      spicedSpotify = cfg.__internal_spotify;
    };

    environment.systemPackages = lib.mkIf cfg.enable cfg.createdPackages;
  };
}
