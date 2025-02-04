lib:
lib.fix (
  self:
  builtins.listToAttrs (
    map
      (x: {
        name = "${x}Modules";
        value = {
          default = self."${x}Modules".spicetify;
          spicetify.imports = [
            ./common.nix
            ./${x}.nix
          ];
        };
      })
      [
        "nixos"
        "homeManager"
        "darwin"
      ]
  )
)
