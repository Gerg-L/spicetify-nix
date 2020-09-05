let
  pkgs = import <nixpkgs> {};
in
  pkgs.fetchFromGitHub {
    owner = "morpheusthewhite";
    repo = "spicetify-themes";
    rev = "17d0670af0739a6591687c6eadf0b47da7ff763d";
    sha256 = "0vjwscmkikjx3h79sydl0wayw9p20zvaigvg7wj39wdxdppsj8np";
  }