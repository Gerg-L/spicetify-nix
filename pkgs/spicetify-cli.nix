{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.39.5";
in
buildGoModule {
  pname = "spicetify-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-vqif3oLDm9SUrkY+qEYHUEmHN+psoK6GNUB+kA6sQ4Q=";
  };

  vendorHash = "sha256-3U/qV81UXS/Xh3K6OnMUyRKeMSBQUHLP64EOQl6TfMY=";

  ldflags = [
    "-s -w"
    "-X 'main.version=Dev'"
  ];

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
