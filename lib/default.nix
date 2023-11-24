pkgs: {
  types = pkgs.callPackage ./types.nix { };

  spicetifyBuilder = pkgs.callPackage ./spicetify-builder.nix { };

  xpuiBuilder = pkgs.callPackage ./xpui-builder.nix { };

  getThemePath =
    theme:
    if (builtins.hasAttr "appendName" theme) then
      (if theme.appendName then "${theme.src}/${theme.name}" else theme.src)
    else
      theme.src;
}
