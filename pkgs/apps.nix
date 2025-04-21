{ sources }:

{
  spicetifyHistory = {
    src = "${sources.bc9123}";
    name = "spicetifyHistory";
  };

  historyInSidebar = {
    src = "${sources.Bergbok-apps_1}";
    name = "History";
  };
  playlistTags = {
    src = "${sources.Bergbok-apps_2}";
    name = "playlistTags";
  };

  enhancifyInstall = {
    src = "${sources.ECE49595-Team-6}";
    name = "enhancifyInstall";
  };

  library = {
    src = "${sources.harbassan-apps}";
    name = "library";
  };
  statistics = {
    src = "${sources.harbassan-apps}";
    name = "stats";
  };

  combinedPlaylists = {
    src = "${sources.jeroentvb-apps}/combined-playlists";
    name = "combinedPlaylists";
  };

  ncsVisualizer = {
    src = "${sources.Konsl-apps}";
    name = "ncs-visualizer";
  };

  studyBanger = {
    src = "${sources.ossd-s24}/dist";
    name = "studyBanger";
  };

  betterLibrary = {
    src = "${sources.Sowgro}/CustomApps/betterLibrary";
    name = "betterLibrary";
  };

  lyricsPlus = {
    src = "${sources.Spicetify-cli}/CustomApps/lyrics-plus";
    name = "lyrics-plus";
  };
  newReleases = {
    src = "${sources.Spicetify-cli}/CustomApps/new-releases";
    name = "new-releases";
  };
  reddit = {
    src = "${sources.Spicetify-cli}/CustomApps/reddit";
    name = "reddit";
  };

  marketplace = {
    src = "${sources.Spicetify-marketplace}";
    name = "marketplace";
  };

  nameThatTune = {
    src = "${sources.theRealPadster-apps}";
    name = "nameThatTune";
  };
}
