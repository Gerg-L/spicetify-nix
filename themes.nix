{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "spicetify-themes";

  src = import(./themes-src.nix);

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';
}