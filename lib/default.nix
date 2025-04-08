{ self, lib }:
{
  mkSpicetify =
    pkgs: config:
    (lib.evalModules {
      specialArgs = {
        inherit pkgs;
      };
      modules = [
        ../modules/standalone.nix
        (import ../modules/common.nix self)
        { programs.spicetify = config; }
      ];
    }).config.programs.spicetify.spicedSpotify;

}
