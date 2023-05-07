{
  stdenv,
  xorg,
  spotify,
  makeWrapper,
  callPackage,
}:
stdenv.mkDerivation {
  pname = "spotifywm";
  inherit ((callPackage ./_sources/generated.nix {}).spotifywmSrc) src version;

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
