self:
builtins.listToAttrs (
  map
    (x: {
      name = "${x}Modules";
      value =
        let
          imports = [
            (import ./common.nix self)
            ./${x}.nix
          ];
        in
        {
          default = { inherit imports; };
          spicetify = { inherit imports; };
        };
    })
    [
      "nixos"
      "homeManager"
      "darwin"
    ]
)
