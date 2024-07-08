{ sources }:
{
  ncsVisualizer = {
    name = "ncs-visualizer";
    src = sources.ncsVisualizerSrc;
  };

  localFiles = {
    name = "localFiles";
    src = sources.localFilesSrc;
  };
  marketplace = {
    name = "marketplace";
    src = sources.marketplaceSrc;
  };
  nameThatTune = {
    name = "nameThatTune";
    src = sources.nameThatTuneSrc;
  };

  newReleases = {
    src = "${sources.officialSrc}/CustomApps/new-releases";
    name = "new-releases";
  };
  reddit = {
    src = "${sources.officialSrc}/CustomApps/reddit";
    name = "reddit";
  };
  lyricsPlus = {
    src = "${sources.officialSrc}/CustomApps/lyrics-plus";
    name = "lyrics-plus";
  };
  historyInSidebar = {
    src = sources.historySidebarSrc;
    name = "History";
  };
  betterLibrary = {
    src = "${sources.betterLibrarySrc}/CustomApps/betterLibrary";
    name = "betterLibrary";
  };
}
