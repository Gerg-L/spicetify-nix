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
}
