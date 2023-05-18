{source, ...}:
with source; {
  # CUSTOMAPPS ----------------------------------------------------------------
  localFiles = {
    name = "localFiles";
    src = localFilesSrc;
    appendName = false;
  };

  marketplace = {
    name = "marketplace";
    src = marketplaceSrc;
    appendName = false;
  };

  nameThatTune = {
    name = "nameThatTune";
    src = nameThatTuneSrc;
    appendName = false;
  };

  official = {
    new-releases = {
      src = "${officialSrc}/CustomApps";
      name = "new-releases";
      appendName = true;
    };
    reddit = {
      src = "${officialSrc}/CustomApps";
      name = "reddit";
      appendName = true;
    };
    lyrics-plus = {
      src = "${officialSrc}/CustomApps";
      name = "lyrics-plus";
      appendName = true;
    };
  };
}
