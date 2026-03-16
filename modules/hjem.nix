{
  lib,
  config,
  ...
}:
{
  packages = lib.mkIf config.programs.spicetify.enable config.programs.spicetify.createdPackages;
}
