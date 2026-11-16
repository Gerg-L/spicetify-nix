{
  lib,
  rustPlatform,
  aws-lc,
  pkg-config,
}:
let
  toml = (lib.importTOML (./Cargo.toml)).package;
in
rustPlatform.buildRustPackage {
  pname = toml.name;
  inherit (toml) version;
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./src
      ./Cargo.toml
      ./Cargo.lock
    ];
  };
  cargoLock.lockFile = ./Cargo.lock;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    aws-lc
  ];

  meta.mainProgram = "fetcher";
}
