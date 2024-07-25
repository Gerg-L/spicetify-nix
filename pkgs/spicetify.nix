{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.37.7";
in
buildGoModule {
  pname = "spicetify";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Sfh2dvqCsV5rl6SmfqV6icJrTcsJy89RibCIRrf2p0k=";
  };

  vendorHash = "sha256-kv+bMyVOJTztn8mNNTK/kp4nvc5m1I5M041s3nPpob8=";

  ldflags = [
    "-s -w"
    "-X 'main.version=Dev'"
  ];

  CGO_ENABLED = "0";

  postInstall = ''
    mv $out/bin/cli $out/bin/spicetify
    ln -s $src/jsHelper $out/bin/jsHelper
    ln -s $src/css-map.json $out/bin/css-map.json
  '';

  meta = {
    description = "Command-line tool to customize Spotify client";
    homepage = "https://github.com/spicetify/cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "spicetify";
  };
}
