{ callPackage, lib, ... }:
{
  types = callPackage ./types.nix { };

  createXpuiINI = lib.generators.toINI {
    mkKeyValue =
      lib.generators.mkKeyValueDefault
        {
          mkValueString =
            v:
            if builtins.isBool v then
              (if v then "1" else "0")
            else
              lib.generators.mkValueStringDefault { } v;
        }
        "=";
  };

  spicetifyBuilder = callPackage ./spicetify-builder.nix { };

  xpuiBuilder = callPackage ./xpui-builder.nix { };

  getThemePath =
    theme:
    if (builtins.hasAttr "appendName" theme) then
      (if theme.appendName then "${theme.src}/${theme.name}" else theme.src)
    else
      theme.src;
}
