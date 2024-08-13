{
  self,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "fetcher";
  version = self.shortRev or self.dirtyShortRev or "dirty";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ./.)) (
      lib.fileset.unions [
        ./src
        ./Cargo.toml
        ./Cargo.lock
      ]
    );
  };
  cargoLock.lockFile = ./Cargo.lock;
  meta.mainProgram = "fetcher";
}
