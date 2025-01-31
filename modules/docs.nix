{
  lib,
  pkgs,
  ...
}:
{
  options.programs.spicetify = {
    windowManagerPatch = lib.mkEnableOption ''
      preloading the spotifywm patch.

      Note: this is only available on linux
    '';
    spotifywmPackage = lib.mkPackageOption pkgs "spotifywm" {
      extraDescription = ''
        Note: this is only available on linux
      '';
    };
  };
}
