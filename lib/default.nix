lib: {
  mkSpicetify =
    pkgs: config:
    (lib.evalModules {
      specialArgs = {
        inherit pkgs;
      };
      modules = [
        ../modules/standalone.nix
        ../modules/common.nix
        { programs.spicetify = config; }
      ];
    }).config.programs.spicetify.spicedSpotify;

}
