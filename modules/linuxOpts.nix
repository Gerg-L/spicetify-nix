{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    windowManagerPatch = lib.mkEnableOption ''
      preloading the spotifywm patch.

      Note: this is only available on linux
    '';
    spotifywmPackage = lib.mkPackageOption pkgs "spotifywm" {
      extraDescription = ''
        Note: this is only available on linux
      '';
    };
    wayland = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      example = true;
      description = ''
        `true` sets chrome flags to use wayland native.

        `false` sets chrome flags to use Xwayland.

        `null` relies on the `$NIXOS_OZONE_WL` environmental variable

        Note: this is only available on linux
      '';
    };
  };
  config.assertions = [
    {
      assertion = config.spotifyPackage.pname != "spotifywm";
      message = ''
        Do not set spotifyPackage to pkgs.spotifywm
        instead enable windowManagerPatch and set spotifywmPackage
      '';
    }
  ];
}
