{
  stdenv,
  fetchFromGitHub,
  xorg,
  spotify,
  makeWrapper,
  ...
}:
stdenv.mkDerivation rec {
  pname = "spotifywm";
  version = "10-25-2022";

  src = fetchFromGitHub {
    owner = "dasJ";
    repo = pname;
    rev = "8624f539549973c124ed18753881045968881745";
    sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
  };

  buildInputs = [xorg.libX11 makeWrapper];

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    install -Dm644 spotifywm.so $out/lib

    cp ${spotify}/bin/spotify $out/bin
    wrapProgram $out/bin/spotify \
        --set LD_PRELOAD "$out/lib/spotifywm.so"
    # wrapper for spotifywm nixpkgs compatibility
    ln -sf $out/bin/spotify $out/bin/spotifywm
  '';
}
