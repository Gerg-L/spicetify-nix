{
  lib,
  rustPlatform,
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

  meta.mainProgram = "fetcher";
}
