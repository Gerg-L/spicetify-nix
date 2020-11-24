let
  pkgs = import <nixpkgs> {};
in
  pkgs.fetchFromGitHub {
    owner = "morpheusthewhite";
    repo = "spicetify-themes";
    rev = "fdadc4c1cfe38ecd22cf828d2c825e0af1dcda9f";
    sha256 = "1k44g8rmf8bh4kk16w4n9z1502ag3w67ad3jx28327ykq8pq5w29";
    fetchSubmodules = true;
  }