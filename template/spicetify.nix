{
  pkgs,
  spicetify-nix,
  ...
}: let
  spicePkgs = spicetify-nix.pkgSets.${pkgs.system};
in {
  # configure spicetify :)
  programs.spicetify = {
    enable = true; # this is the line that will cause spotify to get installed
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "gruvbox";

    enabledCustomApps = with spicePkgs.apps; [
      new-releases
      lyrics-plus
      localFiles
      marketplace
    ];

    enabledExtensions = with spicePkgs.extensions; [
      # "playlistIcons.js" # only needed if not using dribbblish
      "fullAlbumDate.js"
      "showQueueDuration.js"
      "playNext.js"
      "shuffle+.js"
    ];
  };

  xdg.desktopEntries = {
    spotify = {
      name = "Spiced Spotify";
      exec = "spotify";
      icon = "spotify";
      type = "Application";
    };
  };

  imports = [spicetify-nix.homeManagerModule];
}
