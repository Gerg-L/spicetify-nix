{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.39.2";
in
buildGoModule {
  pname = "spicetify-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-Gjcpr6yTtgEsM8rIA1yoZKGGWF4Akh8di2pO4A6a/Zc=";
  };

  vendorHash = "sha256-8LGmIyw8uP4YOjtMRg6MvQtFp0SBhauMQhxt8CHEoUo=";

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
