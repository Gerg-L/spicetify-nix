let
  pkgs = import <nixpkgs> {};
in
  pkgs.fetchFromGitHub {
    owner = "morpheusthewhite";
    repo = "spicetify-themes";
    rev = "443cc26ecec7aa32921a0ba951d1159ac5b48a19";
    sha256 = "04v32s4pq54mvq2pfm8l1511dwijplgw7axdd9fjax25c0rczj62";
  }