{
  lib,
  config,
  ...
}:
{
  programs.spicetify =
    { config, ... }:
    {
      spicedSpotify = config.__internal_spotify;
    };

  environment.systemPackages = lib.mkIf config.programs.spicetify.enable config.programs.spicetify.createdPackages;
}
