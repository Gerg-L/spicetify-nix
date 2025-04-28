{ self, lib }:
{
  mkSpicetify =
    pkgs: module:
    let
      evaled = lib.evalModules {
        specialArgs = {
          inherit pkgs;
        };
        modules = [
          (import ../modules/options.nix self)
          module
        ] ++ lib.optional pkgs.stdenv.isLinux ../modules/linuxOpts.nix;
      };
      failedAssertions = map (x: x.message) (builtins.filter (x: !x.assertion) evaled.config.assertions);
      baseSystemAssertWarn =
        if failedAssertions != [ ] then
          throw "\nFailed assertions:\n${lib.concatMapStrings (x: "- ${x}") failedAssertions}"
        else
          lib.showWarnings evaled.config.warnings;
    in
    baseSystemAssertWarn evaled.config.spicedSpotify;

}
