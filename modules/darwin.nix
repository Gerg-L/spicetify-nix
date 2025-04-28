{
  lib,
  config,
  ...
}:
{
  environment.systemPackages = lib.mkIf config.programs.spicetify.enable config.programs.spicetify.createdPackages;
}
