{source}:
{
  # CUSTOMAPPS ----------------------------------------------------------------
  localFiles = {
    name = "localFiles";
    src = source.localFilesSrc;
    appendName = false;
  };

  marketplace = {
    name = "marketplace";
    src = source.marketplaceSrc;
    appendName = false;
  };

  nameThatTune = {
    name = "nameThatTune";
    src = source.nameThatTuneSrc;
    appendName = false;
  };

  new-releases = {
    src = "${source.officialSrc}/CustomApps";
    name = "new-releases";
    appendName = true;
  };
  reddit = {
    src = "${source.officialSrc}/CustomApps";
    name = "reddit";
    appendName = true;
  };
  lyrics-plus = {
    src = "${source.officialSrc}/CustomApps";
    name = "lyrics-plus";
    appendName = true;
  };
}
