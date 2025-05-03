{
  lib,
  buildNpmPackage,
  importNpmLock,
  nixosOptionsDoc,
  pkgs,

  self,
}:
let
  optionsDoc = nixosOptionsDoc {
    inherit
      (
        (lib.evalModules {
          specialArgs = { inherit pkgs; };
          modules = [
            (import ../modules/options.nix self)
            ../modules/linuxOpts.nix
          ];
        })
      )
      options
      ;
  };
in
buildNpmPackage {
  name = "spicetify-docs";
  src = ./.;

  npmDeps = importNpmLock {
    npmRoot = ./.;
  };

  inherit (importNpmLock) npmConfigHook;
  env.SPICETIFY_OPTIONS_JSON = optionsDoc.optionsJSON;

  # VitePress hangs if you don't pipe the output into a file
  buildPhase = ''
    runHook preBuild

      local exit_status=0
      npm run build > build.log 2>&1 || {
          exit_status=$?
          :
      }
      cat build.log
      return $exit_status

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv .vitepress/dist $out

    runHook postInstall
  '';
  passthru = optionsDoc;
}
