{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "spicetify-1.1.0";

  src = pkgs.fetchurl {
    name = "spicetify-1.1.0-linux-amd64.tar.gz";
    url = https://github.com/khanhas/spicetify-cli/releases/download/v1.1.0/spicetify-1.1.0-linux-amd64.tar.gz;
    sha256 = "sha256:0jsxzw7vzalixi70pps7dq40l5sxwf5ynmr5ycbjzwr4vxdhv0d7";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';
}