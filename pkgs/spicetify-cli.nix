{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.38.9";
in
buildGoModule {
  pname = "spicetify-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-aNDZZzSqVBom499mx6OZlZbeS6UvWJCKs3003TpWITo=";
  };

  vendorHash = "sha256-a6lAVBUoSTqHnAKKvW+egmtupsuy0uB/XGtBaljju1I=";

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
