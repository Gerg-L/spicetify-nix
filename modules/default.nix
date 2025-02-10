builtins.listToAttrs (
  map
    (x: {
      name = "${x}Modules";
      value =
        let
          imports = [
            ./common.nix
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
