{
  callPackage,
  spicetify-cli,
  spotify,
  ...
}: let
  spiceLib = callPackage ../lib {};
  spicePkgs = callPackage ../pkgs {};

  extensions = with spicePkgs.extensions; [
    fullAppDisplay
    shuffle
    hidePodcasts
  ];

  theme = spicePkgs.themes.catppuccin-mocha;

  config-xpui = spiceLib.xpuiBuilder {
    inherit extensions theme;
    cfgXpui = spiceLib.types.defaultXpui;
    cfgColorScheme = "flamingo";
    cfg = {};
    apps = [];
  };
in
  spiceLib.spicetifyBuilder {
    inherit spotify config-xpui extensions theme;
    spicetify = spicetify-cli;
  }
