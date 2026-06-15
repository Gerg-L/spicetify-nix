self:
builtins.listToAttrs (builtins.concatLists (
  map
  (
    target: let
      imports = [
        (import ./common.nix self)
        ./${target.file}.nix
      ];
      value = {
        default = {inherit imports;};
        spicetify = {inherit imports;};
      };
    in
      map (name: {inherit name value;}) target.outputs
  )
  [
    {
      file = "nixos";
      outputs = ["nixosModules"];
    }
    {
      file = "homeManager";
      outputs = ["homeManagerModules" "homeModules"];
    }
    {
      file = "darwin";
      outputs = ["darwinModules"];
    }
    {
      file = "hjem";
      outputs = ["hjemModules"];
    }
  ]
))
