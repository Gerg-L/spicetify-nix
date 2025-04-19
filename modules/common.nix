self:
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.programs.spicetify = lib.mkOption {
    type = lib.types.submoduleWith {
      specialArgs = { inherit pkgs; };
      modules = [
        (import ./options.nix self)
      ];
    };
  };

  config = lib.mkIf config.programs.spicetify.enable {

    warnings = map (warning: "programs.spicetify: ${warning}") config.programs.spicetify.warnings;
    assertions = map (assertion: {
      inherit (assertion) assertion;
      message = "programs.spicetify: ${assertion.message}";
    }) config.programs.spicetify.assertions;
  };
  _file = ./common.nix;
}
